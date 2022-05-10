require "base64"

class Payment::PagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:notify, :success, :failure]

  # We don't want rails's own CSRF protection, because the post request will come from mypos domain.
  # We will implement our own protection in the controller by validating their signature.
  skip_before_action :verify_authenticity_token, only: [:notify, :success, :failure]

  def checkout
    @order_id = params[:id]
    # In case of MondoCon tickets, the order_id starts with the prefix MC:
    if @order_id.start_with?('MC')
      # We strip the MC prefix to get the ticket_order.id:
      ticket_id = @order_id[2 .. -1]
      ticket_order = TicketOrder.find(ticket_id)
      @article = ticket_order.ticket.convention.name + " " +  ticket_order.ticket.name
      @quantity = ticket_order.quantity
      @price_per_ticket = ticket_order.ticket.price
      @amount = ticket_order.total_price
    end

    @payment_params = {
        IpcMethod: 'IPCPurchase',
        IpcVersion: 1.4,
        IpcLanguage: 'EN',
        # test environment parameters:
        SID: '000000000000010',
        WalletNumber: 61938166610,
        KeyIndex: 1,

        # live environment parameters:
        # sid: Rails.configuration.x.mypos.sid,
        # walletNumber: Rails.configuration.x.mypos.wallet_number,
        # KeyIndex: Rails.configuration.x.mypos.key_index,

        URL_Notify: payment_notify_url.split("?")[0],
        # URL_Notify: 'https://mondoreg.herokuapp.com/notify',
        URL_OK: payment_success_url.split("?")[0],
        URL_Cancel: payment_failure_url.split("?")[0],
        Amount: @amount,
        Currency: 'HUF',
        OrderID: @order_id,

        PaymentMethod: 1,
        CardTokenRequest: 0,
        PaymentParametersRequired: 3,
        CartItems: 1,
        Article_1: @article,
        Quantity_1: @quantity,
        Price_1: @price_per_ticket.to_i,
        Amount_1: @amount,
        Currency_1: 'HUF',
    }
    @payment_params[:Signature] = generate_signature(@payment_params)

    @url = 'https://mypos.com/vmp/checkout-test'
  end


  def notify
    pp params

    certificate = Rails.configuration.x.mypos.certificate
    pub_key_id = OpenSSL::X509::Certificate.new(certificate).public_key
    signature = params["Signature"]

    # To check signature first remove signature from POST data array also remove controller and action
    params.delete "Signature"
    params.delete "controller"
    params.delete "action"
    data = params
    # Concatenate all values
    conc_data = Base64.strict_encode64( data.values.join("-") )
    # Then we validate
    is_valid = pub_key_id.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), conc_data)
    if is_valid
      order_id = params[:OrderID]
      if order_id.start_with?('MC')
        ticket_id = order_id[2 .. -1]
        ticket_order = TicketOrder.find(ticket_id)
        ticket_order.confirm
        render plain: "OK"
      end
    else
      # Return an empty document with error 401:
      head :unauthorized
    end
  end

  def success
    if test_signature(params)
      order_id = params[:OrderID]
      flash[:notice] = "A #{order_id} rendelés befizetése sikeres"
      redirect_to root_path
      # TODO átirányítás egy oldalra, ahol elmondjuk, hogy tud bejutni a jeggyel.
    else
      # Return an empty document with error 401:
      head :unauthorized
    end
  end

  def failure
    if test_signature(params)
      order_id = params[:OrderID]
      flash[:danger] = "A #{order_id} rendelés befizetése sikertelen"
      redirect_to root_path
      # TODO átirányítás újra a payment felületre, ahol újra választhat fizetési módot.
    else
      # Return an empty document with error 401:
      head :unauthorized
    end
  end

  def test_signature(params)
    # Test environment certificate:
    certificate = Rails.configuration.x.mypos.test_certificate

    # certificate = Rails.configuration.x.mypos.certificate

    pub_key_id = OpenSSL::X509::Certificate.new(certificate).public_key
    signature = params["Signature"]

    # To check signature first remove signature from POST data array also remove controller and action
    params.delete "Signature"
    params.delete "controller"
    params.delete "action"
    data = params
    # Concatenate all values
    conc_data = Base64.strict_encode64( data.values.join("-") )
    # Then we validate
    pub_key_id.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), conc_data)
  end

  def generate_signature(params)
    # Test environment private key:
    private_key = OpenSSL::PKey::RSA.new(Rails.configuration.x.mypos.test_private_key)

    # Real private key:
    # private_key = OpenSSL::PKey::RSA.new(Rails.configuration.x.mypos.private_key)

    concatenated_params = Base64.strict_encode64(params.values.join('-'))
    signature = private_key.sign(OpenSSL::Digest::SHA256.new, concatenated_params)
    Base64.strict_encode64(signature)
  end

end

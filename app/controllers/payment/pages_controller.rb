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
    
      if (ticket_order.ticket.sale_end < Date.today)
        flash[:danger] = t('ticketing.sale_over')
        redirect_to root_path
      end
    elsif @order_id.start_with?('MAG')
      # We strip the MAG prefix to get the ticket_order.id:
      subscription_id = @order_id[3 .. -1]
      mondo_subscription = MondoSubscription.find(subscription_id)
      @article = mondo_subscription.duration.to_s + " month sub"
      @quantity = 1
      @amount = @price_per_ticket = MondoSubAttrib.find_by(key: @article).value
    end

    @payment_params = {
        IpcMethod: 'IPCPurchase',
        IpcVersion: 1.4,
        IpcLanguage: 'EN',

        SID: Rails.configuration.x.mypos.testing ? '000000000000010' : Rails.configuration.x.mypos.sid,
        walletNumber: Rails.configuration.x.mypos.testing ? 61938166610 : Rails.configuration.x.mypos.wallet_number,
        KeyIndex: Rails.configuration.x.mypos.testing ? 1 : Rails.configuration.x.mypos.key_index,

        URL_Notify: payment_notify_url.split("?")[0],
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
  end


  def notify
    if test_signature(params)
      order_id = params[:OrderID]
      if order_id.start_with?('MC')
        ticket_id = order_id[2 .. -1]
        ticket_order = TicketOrder.find(ticket_id)
        ticket_order.confirm('mypos')
        render plain: "OK"
      elsif 
        order_id.start_with?('MAG')
        subscription_id = @order_id[3 .. -1]
        mondo_subscription = MondoSubscription.find(subscription_id)
        mondo_subscription.confirm
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
      flash[:notice] = t('ticketing.user_side.successful_payment', order_id: order_id)
      redirect_to root_path
    else
      # Return an empty document with error 401:
      head :unauthorized
    end
  end

  def failure
    if test_signature(params)
      order_id = params[:OrderID]
      flash[:danger] = t('ticketing.user_side.unsuccessful_payment', order_id: order_id)
      redirect_to root_path
      # TODO átirányítás újra a payment felületre, ahol újra választhat fizetési módot.
    else
      # Return an empty document with error 401:
      head :unauthorized
    end
  end

  def test_signature(params)
    certificate = Rails.configuration.x.mypos.testing ? Rails.configuration.x.mypos.test_certificate : Rails.configuration.x.mypos.certificate

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
    private_key = Rails.configuration.x.mypos.testing ? OpenSSL::PKey::RSA.new(Rails.configuration.x.mypos.test_private_key) : OpenSSL::PKey::RSA.new(Rails.configuration.x.mypos.private_key)

    concatenated_params = Base64.strict_encode64(params.values.join('-'))
    signature = private_key.sign(OpenSSL::Digest::SHA256.new, concatenated_params)
    Base64.strict_encode64(signature)
  end

end

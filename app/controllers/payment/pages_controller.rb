class Payment::PagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:notify]

  # We don't want rails's own CSRF protection, because the post request will come from mypos domain.
  # We will implement our own protection in the controller by validating their signature.
  skip_before_action :verify_authenticity_token, only: [:notify]

  def checkout
    @order_id = params[:id]
    # In case of MondoCon tickets, the order_id starts with the prefix MC
    if @order_id.start_with?('MC')
      @order_type = "ticket"
      ticket_id = @order_id[2 .. -1]
      @ticket_order = TicketOrder.find(ticket_id)
    end
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

end

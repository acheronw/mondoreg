class Payment::PagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:notify]

  # TODO - I don't understand what this verify_authenticity_token is:
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
  end

end

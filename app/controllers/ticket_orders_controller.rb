class TicketOrdersController < ApplicationController


  def create
    @ticket_order = current_user.ticket_orders.build(ticket_order_params)
    @ticket_order.status = "pending"
    tickets_on_sale = Ticket.on_sale.pluck(:id)
    unless tickets_on_sale.include? @ticket_order.ticket_id
      # The user tried to hack the params and by a ticket that's not on sale.
      # I was unable to put this filter into the strong params permit method.
      flash[:danger] = "That ticket type is not on sale!"
      redirect_to root_path
    else
      if @ticket_order.save
        flash[:success] = t('ticketing.user_side.order_placed_message')
        ApplicationMailer.ticket_ordered_email(@ticket_order).deliver_now
        redirect_to root_path
      else
        flash[:danger] = @ticket_order.errors.full_messages
        redirect_to root_path
      end
    end
  end


  private
    def ticket_order_params
      params.require(:ticket_order).permit(:quantity, :ticket_id)
    end

end

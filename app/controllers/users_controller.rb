class UsersController < ApplicationController


  def reminder_email
    @ticket_order = current_user.ticket_orders.requires_attention.last
    ApplicationMailer.ticket_ordered_email(@ticket_order).deliver_now
    flash[:success] = t('ticketing.user_side.resent_instructions_message')
    redirect_to root_path
  end

end

class StaticPagesController < ApplicationController


  def home
    # This is a resource for the buy ticket form:
    @ticket_order = current_user.ticket_orders.build if user_signed_in?
  end

  def help
  end



end
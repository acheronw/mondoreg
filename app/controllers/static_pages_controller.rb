class StaticPagesController < ApplicationController


  def home
    # This is a resource for the buy ticket form:
    @ticket_order = current_user.ticket_orders.build if user_signed_in?
  end

  def help
  end

  def mondo_magazine
    if user_signed_in?
      redirect_to edit_user_path(current_user)
    else
      store_location_for(:user, request.fullpath)
      authenticate_user!
    end
  end

  def ticket_stats
  end

end

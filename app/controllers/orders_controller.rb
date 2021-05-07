class OrdersController < ApplicationController

  def show
    @order = Order.where(id: params[:id]).first
    if @order.blank? || @order.user != current_user
      redirect_to root_path
    end
  end

  def index
    # This is filtered to show only the current users orders
    @orders = current_user.orders.order(id: :desc)
  end

  def submit_order
    @order = Order.find(params[:id])
    if current_user == @order.user
      if @order.check_and_update_cart_for_availablity
        flash[:danger] = t('webshop.order.items_became_unavailable')
        redirect_to @order
      else
        @order.submit_order
        flash[:success] = t('webshop.order.successfully_submitted')
        redirect_to root_path
      end
    else
      flash[:danger] = "Only the user himself can submit his orders"
      redirect_to root_path
    end

  end

end
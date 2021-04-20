class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  def index
    # This is filtered to show only the current users orders
    @orders = current_user.orders.order(id: :desc)
  end

  def submit_order
    @order = Order.find(params[:id])
    if current_user == @order.user
      @order.submit_order
    else
      flash[:danger] = "Only the user himself can submit his orders"
    end
    redirect_to root_path
  end

end
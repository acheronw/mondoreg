class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  def index
    # This is filtered to show only the current users orders
    @orders = current_user.orders
  end


end
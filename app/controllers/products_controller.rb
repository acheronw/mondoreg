class ProductsController < ApplicationController

  def show
    @product = Product.find(params[:id])
  end

  def add_to_basket
    @product = Product.find(params[:id])
    current_order = current_user.orders.last
    if current_order.status == 'in_cart'
      current_order.add_product(@product)
    else
      current_order = Order.create(user: current_user, status: 'in_cart')
      current_order.add_product(@product)
    end
    redirect_to current_order
  end

  def take_from_basket
    @product = Product.find(params[:id])
    current_order = current_user.orders.last
    if current_order.status == 'in_cart'
      current_order.decrement_product(@product)
    end
    if current_order.destroyed?
      redirect_to root_path
    else
      redirect_to current_order
    end
  end


end
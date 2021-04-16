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
      # TODO - Create new order
    end
    redirect_to current_order
  end

  def take_from_basket
    @product = Product.find(params[:id])
    current_order = current_user.orders.last
    if current_order.status == 'in_cart'
      current_order.decrement_product(@product)
    end
    # TODO ha megszűnt ezzel a rendelés, máshová kell redirect!
    redirect_to current_order

  end


end
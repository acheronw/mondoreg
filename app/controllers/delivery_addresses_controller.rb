class DeliveryAddressesController < ApplicationController

  def new
    @delivery_address = DeliveryAddress.new
    @delivery_address.addressable_id = params[:addressable_id]
    @delivery_address.addressable_type = params[:addressable_type]

  end

  def create
    @delivery_address = DeliveryAddress.new(address_params)
    if @delivery_address.addressable_type == 'User'
      if current_user.id = @delivery_address.addressable_id
        if @delivery_address.save
          # If the user has an open order without an address  defined, put this address there as well
          open_order = current_user.orders.last
          if open_order.present? && open_order.status == 'in_cart' && open_order.delivery_address.blank?
            @order_delivery_address = DeliveryAddress.new(address_params)
            @order_delivery_address.addressable = open_order
            @order_delivery_address.save
          end
          redirect_to root_path
        else
          render 'new'
        end
      else
        # Someone tried to hack the params
        redirect_to root_path
      end
    elsif @delivery_address.addressable_type == 'Order'
      order = Order.find(@delivery_address.addressable_id)
      if order.status == 'in_cart'
        if @delivery_address.save
          redirect_to order
        else
          render 'new'
        end
      else
        # Only unsubmitted orders can be edited.
        redirect_to root_path
      end
    else
      # Someone tried to hack the params
      redirect_to root_path
    end
  end

  def edit
    @delivery_address = DeliveryAddress.find(params[:id])
  end

  def update
    @delivery_address = DeliveryAddress.find(params[:id])
    if @delivery_address.addressable_type == 'User'
      if @delivery_address.addressable == current_user
        # Only the user itself can change his default address
        if @delivery_address.update(update_address_params)
          # If the user has an open order without an address  defined, put this address there as well
          open_order = current_user.orders.last
          if open_order.present? && open_order.status == 'in_cart' && open_order.delivery_address.blank?
            @order_delivery_address = DeliveryAddress.new(address_params)
            @order_delivery_address.addressable = open_order
            @order_delivery_address.save
          end
          redirect_to root_path
        else
          render 'edit'
        end
      end
    elsif @delivery_address.addressable_type == 'Order'
      if @delivery_address.addressable.user == current_user && @delivery_address.addressable.status == 'in_cart'
        # Only the owner of the order can change address
        if @delivery_address.update(update_address_params)
          redirect_to @delivery_address.addressable
        else
          render 'edit'
        end

      end
    else
      # This is impossible
    end

    @delivery_address.update(address_params)

  end

  def address_params
    params.require(:delivery_address).permit(:name,
                                             :city,
                                             :zip,
                                             :street_address,
                                             :phone,
                                             :addressable_id,
                                             :addressable_type
                                             )
  end

  def update_address_params
    params.require(:delivery_address).permit(:name,
                                             :city,
                                             :zip,
                                             :street_address,
                                             :phone,
    )
  end

end
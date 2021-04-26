ActiveAdmin.register Order do

  permit_params :user_id, :status, :comment, :total_price, :date_submitted, :date_shipped


  show do
    attributes_table do
      row :user
      row :status
      row :comment
      row :total_price
      if order.delivery_address.present?
        row :delivery_address
      end

      table_for order.line_items do
        column "Items" do |line_item|
          link_to line_item.product.name, [ :admin, line_item ]
        end
        column "Quantity" do |line_item|
          line_item.quantity
        end
      end

    end
  end

end
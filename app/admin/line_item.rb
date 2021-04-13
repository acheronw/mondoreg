ActiveAdmin.register LineItem do

  permit_params :order_id, :product_id, :quantity

end
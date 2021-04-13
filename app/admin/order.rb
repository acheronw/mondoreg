ActiveAdmin.register Order do

  permit_params :user_id, :status, :comment, :total_price, :date_submitted, :date_shipped

end
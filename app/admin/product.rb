ActiveAdmin.register Product do

  menu if: proc{ current_admin_user.is_super?}


  permit_params :name, :status, :product_category_id, :author, :isbn, :publication_date, :price, :description, :page_count

end
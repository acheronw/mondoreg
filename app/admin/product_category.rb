ActiveAdmin.register ProductCategory do
  menu if: proc{ current_admin_user.is_super?}


  # index do
  #   column :name
  #   selectable_column
  #   column 'Parent' do | product_categories |
  #     product_categories.parent
  #   end
  #   column :description
  #   actions
  # end
  permit_params :name, :parent_id, :description, :status

end

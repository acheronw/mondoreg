ActiveAdmin.register Ticket do
  menu if: proc{ current_admin_user.is_super?}

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :name, :convention_id, :sale_start, :sale_end, :price, :quantity


  index do
    selectable_column
    column 'Convention' do | ticket |
      ticket.convention
    end
    column :name
    column :price
    column :sale_start
    column :sale_end
    column :quantity
    actions
  end


end

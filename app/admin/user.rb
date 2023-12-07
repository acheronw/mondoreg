ActiveAdmin.register User do

  menu if: proc{ current_admin_user.is_super?}
  permit_params :subscription_uptime, :subscription_comment, :subscription_name,
                :subscription_email, :subscription_zip, :subscription_city,
                :subscription_address


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


end

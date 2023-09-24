ActiveAdmin.register MondoSubAttrib do
  menu if: proc{ current_admin_user.is_super?}
  permit_params :key, :value

end

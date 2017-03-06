ActiveAdmin.register Competition do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :name, :convention_id, :subtype, :max_group_size, :applications_start, :applications_end




end

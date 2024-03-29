ActiveAdmin.register Competition do
  menu if: proc{ current_admin_user.access_competitions?}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :name, :convention_id, :subtype, :max_group_size, :max_applications,
                :applications_start, :applications_end, :admin_email, :welcome_info,
                :combo_comp, :schedule_options, :ppl_per_schedule




end

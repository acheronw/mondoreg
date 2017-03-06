ActiveAdmin.register CompApplication do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :competition_id, :user_id, :character_name, :character_source, :status, :perf_requests, group_members: []

end

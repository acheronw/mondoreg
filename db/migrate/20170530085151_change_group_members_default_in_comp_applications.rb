class ChangeGroupMembersDefaultInCompApplications < ActiveRecord::Migration[5.0]
  def change
    change_column_default :comp_applications, :group_members, nil
  end
end

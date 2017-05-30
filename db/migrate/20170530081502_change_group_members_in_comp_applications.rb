class ChangeGroupMembersInCompApplications < ActiveRecord::Migration[5.0]
  def self.up
    change_column :comp_applications, :group_members, :text, default: nil
  end

  def self.down
    change_column :comp_applications, :group_members, :string, array: true, default: []
  end
end

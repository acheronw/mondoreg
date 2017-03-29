class AddGroupNameToCompApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :group_name, :string
  end
end

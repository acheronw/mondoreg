class AddAdminMsgToCompApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :admin_msg, :text
  end
end

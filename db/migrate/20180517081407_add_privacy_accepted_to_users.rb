class AddPrivacyAcceptedToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :privacy_accepted, :boolean, default: true
    User.update_all(privacy_accepted: false)
  end

  def down
    remove_column :users, :privacy_accepted, :boolean
  end

end

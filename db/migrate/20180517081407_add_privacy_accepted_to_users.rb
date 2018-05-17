class AddPrivacyAcceptedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :privacy_accepted, :boolean, default: false
  end
  
end

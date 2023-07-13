class AddSubscriptionToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscription_email, :string
    add_column :users, :subscription_name, :string
    add_column :users, :subscription_zip, :integer
    add_column :users, :subscription_city, :string
    add_column :users, :subscription_address, :string
    add_column :users, :subscription_uptime, :integer
    add_column :users, :subscription_comment, :string
  end
end

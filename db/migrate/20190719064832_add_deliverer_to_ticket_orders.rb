class AddDelivererToTicketOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_orders, :deliverer, :integer
  end
end

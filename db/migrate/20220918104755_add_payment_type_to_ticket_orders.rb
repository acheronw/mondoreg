class AddPaymentTypeToTicketOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :ticket_orders, :payment_type, :string
  end
end

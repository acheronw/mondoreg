class AddPaymentDateToTicketOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :ticket_orders, :payment_date, :datetime
  end
end

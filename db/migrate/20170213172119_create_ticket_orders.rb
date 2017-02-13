class CreateTicketOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_orders do |t|
      t.references :user, foreign_key: true
      t.references :ticket, foreign_key: true
      t.integer :quantity
      t.string :status

      t.timestamps
    end
  end
end

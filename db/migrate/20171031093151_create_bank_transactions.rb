class CreateBankTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_transactions do |t|
      t.string :csv_line
      t.float :amount_of_transaction
      t.date :date_of_transaction
      t.string :comment_of_transaction
      t.string :sender_of_transaction
      t.string :order_id_code
      t.references :ticket_order, foreign_key: true
      t.string :status
      t.timestamps
    end
  end
end

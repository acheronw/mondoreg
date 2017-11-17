class AddIndexToBankTransactions < ActiveRecord::Migration[5.0]
  def change
    add_index :bank_transactions, :csv_line, unique: true
  end
end

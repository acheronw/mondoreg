class AddProblemToBankTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :bank_transactions, :problem, :string
  end
end

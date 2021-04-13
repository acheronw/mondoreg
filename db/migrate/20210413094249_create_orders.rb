class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.string :comment
      t.integer :total_price
      t.date :date_submitted
      t.date :date_shipped

      t.timestamps
    end
  end
end

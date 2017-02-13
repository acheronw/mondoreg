class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :name
      t.references :convention, foreign_key: true
      t.datetime :sale_start
      t.datetime :sale_end
      t.decimal :price
      t.integer :quantity

      t.timestamps
    end
  end
end

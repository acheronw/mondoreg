class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.belongs_to :product_category, null: false, foreign_key: true
      t.string :status
      t.string :author
      t.string :isbn
      t.date :publication_date
      t.integer :page_count
      t.integer :price
      t.text :description

      t.timestamps
    end
  end
end

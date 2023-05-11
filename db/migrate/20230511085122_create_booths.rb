class CreateBooths < ActiveRecord::Migration[6.1]
  def change
    create_table :booths do |t|
      t.references :user, null: false, foreign_key: true
      t.references :convention, null: false, foreign_key: true
      t.integer :booth_number
      t.string :booth_name
      t.string :status

      t.timestamps
    end
  end
end

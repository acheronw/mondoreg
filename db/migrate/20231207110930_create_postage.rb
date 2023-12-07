class CreatePostage < ActiveRecord::Migration[6.1]
  def change
    create_table :postages do |t|
      t.references :user, null: false, foreign_key: true
      t.string :item

      t.timestamps
    end
  end
end

class CreateMondoSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :mondo_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :status
      t.integer :duration

      t.timestamps
    end
  end
end

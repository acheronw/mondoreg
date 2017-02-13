class CreateConventions < ActiveRecord::Migration[5.0]
  def change
    create_table :conventions do |t|
      t.string :name
      t.datetime :opening
      t.datetime :relevance_date

      t.timestamps
    end
  end
end

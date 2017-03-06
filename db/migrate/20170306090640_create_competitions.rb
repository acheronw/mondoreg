class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.references :convention, foreign_key: true
      t.string :subtype
      t.integer :max_group_size
      t.datetime :applications_start
      t.datetime :applications_end

      t.timestamps
    end
  end
end

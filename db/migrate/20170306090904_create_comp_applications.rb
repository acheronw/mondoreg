class CreateCompApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :comp_applications do |t|
      t.references :competition, foreign_key: true
      t.references :user, foreign_key: true
      t.string :character_name
      t.string :character_source
      t.string :status
      t.string :perf_requests
      t.string :group_members, array: true, default: []

      t.timestamps
    end
  end
end

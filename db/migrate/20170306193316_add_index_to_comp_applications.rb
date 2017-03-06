class AddIndexToCompApplications < ActiveRecord::Migration[5.0]
  def change
    add_index :comp_applications, [:user_id, :competition_id], unique: true
  end
end

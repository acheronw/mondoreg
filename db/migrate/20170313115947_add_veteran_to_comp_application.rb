class AddVeteranToCompApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :veteran, :boolean
  end
end

class AddAgeToCompApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :age, :boolean
  end
end

class AddAppearanceNoToCompApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :appearance_no, :integer
  end
end

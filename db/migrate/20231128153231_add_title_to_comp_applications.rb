class AddTitleToCompApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :comp_applications, :title, :string
    add_column :comp_applications, :description, :string
    add_column :comp_applications, :includes_effects, :bool
    add_column :comp_applications, :music_description, :string
  end
end

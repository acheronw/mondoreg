class AddSelectedMusicToCompApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :selected_music, :string
  end
end

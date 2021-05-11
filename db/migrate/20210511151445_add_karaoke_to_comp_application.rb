class AddKaraokeToCompApplication < ActiveRecord::Migration[6.1]
  def change
    add_column :comp_applications, :karaoke1, :string
    add_column :comp_applications, :karaoke2, :string
  end
end

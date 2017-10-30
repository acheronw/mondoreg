class AddWelcomeInfoToCompetitions < ActiveRecord::Migration[5.0]
  def up
    add_column :competitions, :welcome_info, :string
  end

  def down
    remove_column :competitions, :welcome_info, :string
  end
end

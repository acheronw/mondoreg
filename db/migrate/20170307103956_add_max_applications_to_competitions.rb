class AddMaxApplicationsToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :max_applications, :integer
  end
end

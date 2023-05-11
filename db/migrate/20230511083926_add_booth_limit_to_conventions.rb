class AddBoothLimitToConventions < ActiveRecord::Migration[6.1]
  def change
    add_column :conventions, :booth_limit, :integer
  end
end

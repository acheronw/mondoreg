class AddAaOpeningTimeToConventions < ActiveRecord::Migration[6.1]
  def change
    add_column :conventions, :aa_opening_time, :datetime
  end
end

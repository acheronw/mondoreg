class AddAgeInYearsToCompApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :comp_applications, :age_in_years, :integer
  end
end

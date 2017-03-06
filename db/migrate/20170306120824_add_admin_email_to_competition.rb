class AddAdminEmailToCompetition < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :admin_email, :string
  end
end

class AddNicknameToCompApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :nickname, :string
  end
end

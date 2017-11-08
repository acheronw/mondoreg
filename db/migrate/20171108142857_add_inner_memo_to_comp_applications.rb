class AddInnerMemoToCompApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :comp_applications, :inner_memo, :text
  end
end

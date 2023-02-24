class AddColumnsToCompetition < ActiveRecord::Migration[6.1]
  def change
    add_column :competitions, :combo_comp, :string
    add_column :competitions, :schedule_options, :string
    add_column :competitions, :ppl_per_schedule, :int
    add_column :comp_applications, :combo_comp, :string
    add_column :comp_applications, :schedule_picked, :string
  end
end

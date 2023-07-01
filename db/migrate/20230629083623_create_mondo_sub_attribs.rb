class CreateMondoSubAttribs < ActiveRecord::Migration[6.1]
  def change
    create_table :mondo_sub_attribs do |t|
      t.integer :pack_6
      t.integer :pack_12
      t.datetime :pack_last_date

      t.timestamps
    end
  end
end

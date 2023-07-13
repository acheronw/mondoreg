class CreateMondoSubAttribs < ActiveRecord::Migration[6.1]
  def change
    create_table :mondo_sub_attribs do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end

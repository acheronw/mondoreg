class CreateMondoSubsMails < ActiveRecord::Migration[6.1]
  def change
    create_table :mondo_subs_mails do |t|
      t.string :sub_name
      t.integer :sub_zip
      t.string :sub_city
      t.string :sub_address
      t.datetime :sub_mail_date

      t.timestamps
    end
  end
end

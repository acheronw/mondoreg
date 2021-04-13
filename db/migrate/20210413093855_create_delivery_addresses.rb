class CreateDeliveryAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :delivery_addresses do |t|
      t.string :name
      t.string :city
      t.string :zip
      t.string :street_address
      t.string :phone

      t.references :addressable, polymorphic: true

      t.timestamps
    end
  end
end

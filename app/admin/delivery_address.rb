ActiveAdmin.register DeliveryAddress do

  permit_params :name, :city, :zip, :street_address, :phone, :addressable

end
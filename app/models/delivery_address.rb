class DeliveryAddress < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :name, presence: true
  validates :city, presence: true
  validates :zip, presence: true
  validates :street_address, presence: true
  validates :phone, presence: true


end

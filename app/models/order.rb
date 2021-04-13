class Order < ApplicationRecord
  belongs_to :user
  has_one :delivery_address, as: :addressable

  has_many :line_items
  has_many :products, :through => :line_items

  validates :status, :inclusion => { :in => ['in_cart', 'submitted', 'processed', 'shipping', 'delivered', 'returned'],
                                     message: "%value is not a valid order status" }
end

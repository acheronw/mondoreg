class Order < ApplicationRecord
  belongs_to :user
  has_one :address, as: :addressable

  has_many :line_items
  has_many :products, :through => :line_items

  validates :status, :inclusion => { :in => ['submitted', 'processed', 'shipping', 'delivered', 'returned'],
                                     message: "%value is not a valid order status" }
end

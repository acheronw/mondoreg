class Product < ApplicationRecord
  validates :name, presence: true
  validates :status, :inclusion => { :in => ['hidden', 'for sale'],
                                     message: "%value is not a valid product category status" }
  validates :price, presence: true

  belongs_to :product_category


end
class ProductCategory < ApplicationRecord
  validates :name, presence: true
  validates :status, :inclusion => { :in => ['hidden', 'for sale'],
                                     message: "%value is not a valid product category status" }

  belongs_to :parent, class_name: 'ProductCategory', optional: true
  has_many :children, class_name: 'ProductCategory', foreign_key: 'parent_id'

  has_many :products

end

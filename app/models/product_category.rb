class ProductCategory < ApplicationRecord
  validates :name, presence: true
  validates :status, :inclusion => { :in => ['hidden', 'for sale'],
                                     message: "%value is not a valid product category status" }

  belongs_to :parent, class_name: 'ProductCategory', optional: true
  has_many :children, class_name: 'ProductCategory', foreign_key: 'parent_id'

  has_one_attached :product_image
  validates :product_image, content_type: /\Aimage\/.*\Z/

  has_many :products

  def taxonomic_path
    if self.parent.present?
      result = self.parent.taxonomic_path
      result.push(self)
    else
      [self]
    end
  end

end

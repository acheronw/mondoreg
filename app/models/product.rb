class Product < ApplicationRecord
  validates :name, presence: true
  validates :status, :inclusion => { :in => ['hidden', 'for sale'],
                                     message: "%value is not a valid product category status" }
  validates :price, presence: true

  belongs_to :product_category

  has_one_attached :product_image
  validates :product_image, content_type: /\Aimage\/.*\Z/

  def taxonomic_path
    result = self.product_category.taxonomic_path
    result.push(self)
  end

  def status_localized
    return case status
           when "for sale"
             I18n.t('webshop.for_sale')
           when "hidden"
             I18n.t('webshop.hidden')
           end
  end

end
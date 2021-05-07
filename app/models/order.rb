class Order < ApplicationRecord
  belongs_to :user
  has_one :delivery_address, dependent: :destroy, as: :addressable

  has_many :line_items, dependent: :destroy
  has_many :products, :through => :line_items

  validates :status, :inclusion => { :in => ['in_cart', 'submitted', 'processed', 'shipping', 'delivered', 'returned'],
                                     message: "%value is not a valid order status" }

  after_create :copy_users_delivery_address

  def add_product(product)
    product_already_in_basket = self.line_items.find_by(product: product)
    if product_already_in_basket.blank?
      LineItem.create(order: self, product: product, quantity: 1)
    else
      product_already_in_basket.quantity += 1
      product_already_in_basket.save
    end
    self.line_items.reload
    recalculate_total_price
  end

  def decrement_product(product)
    product_already_in_basket = self.line_items.find_by(product_id: product.id)
    if product_already_in_basket.quantity == 1
      product_already_in_basket.destroy
    else
      product_already_in_basket.quantity -= 1
      product_already_in_basket.save
    end
    self.line_items.reload
    if self.line_items.blank?
      self.destroy
    else
      recalculate_total_price
    end
  end

  def recalculate_total_price
    new_total_price = self.line_items.inject(0){| sum, li | sum + (li.quantity * li.product.price) }
    self.update(total_price: new_total_price)
  end

  def submit_order
    recalculate_total_price
    self.date_submitted = Time.current
    self.update(status: 'submitted')
  end

  def check_and_update_cart_for_availablity
    made_any_change = false
    self.line_items.each do | line_item |
      if line_item.product.status != 'for sale'
        line_item.destroy
        made_any_change = true
      end
    end
    if made_any_change
      self.line_items.reload
      if self.line_items.blank?
        self.destroy
      else
        recalculate_total_price
      end
    end
    return made_any_change
  end

  private
  def copy_users_delivery_address
    address = self.user.delivery_address
    if address.present?
      order_delivery_address = address.dup
      order_delivery_address.addressable = self
      order_delivery_address.save
    end
  end

end

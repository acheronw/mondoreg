class DeliveryAddress < ApplicationRecord
  belongs_to :addressable, polymorphic: true

end

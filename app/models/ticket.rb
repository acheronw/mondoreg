class Ticket < ApplicationRecord
  belongs_to :convention, inverse_of: :tickets
  validates :convention_id, presence: true

  scope :active, -> { joins(:convention).merge(Convention.active) }
  scope :on_sale, -> { where("sale_start <= ?", Date.today).where("sale_end >= ?", Date.today) }

  has_many :ticket_orders, inverse_of: :ticket, dependent: :destroy



end

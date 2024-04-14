class Ticket < ApplicationRecord
  belongs_to :convention, inverse_of: :tickets
  validates :convention_id, presence: true

  scope :active, -> { joins(:convention).merge(Convention.active) }
  scope :on_sale, -> { where("sale_start <= ?", DateTime.current).where("sale_end >= ?", DateTime.current) }
  scope :not_full, -> { select { | ticket | not ticket.full? } }

  has_many :ticket_orders, inverse_of: :ticket, dependent: :destroy

  def full?
    if self.quantity
      self.ticket_orders.where(status: ['accepted', 'pending']).count >= self.quantity
    else
      # A competition with no limit of applications can never be full
      false
    end
  end


end

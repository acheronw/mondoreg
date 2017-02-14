class TicketOrder < ApplicationRecord
  validates :status, :inclusion => { :in => ['pending', 'accepted', 'rejected'],
                                     message: "%value is not a valid ticket status" }

  belongs_to :user, inverse_of: :ticket_orders
  belongs_to :ticket, inverse_of: :ticket_orders

  scope :active, -> { joins(:ticket).merge(Ticket.active) }

  scope :pending, -> { where(status: 'pending') }
  scope :relevant, -> { where(status: ['pending', 'accepted']) }

end

class Ticket < ApplicationRecord
  belongs_to :convention

  has_many :ticket_orders
end

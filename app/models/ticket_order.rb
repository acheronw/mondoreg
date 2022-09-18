class TicketOrder < ApplicationRecord
  validates :status, :inclusion => { :in => ['pending', 'accepted', 'rejected','delivered', 'refunded'],
                                     message: "%value is not a valid ticket status" }
  validates :user_id, presence: true
  validates :ticket_id, presence: true
  validates :quantity, presence: true
  validates :quantity, :numericality =>  { :greater_than => 0 }


  belongs_to :user, inverse_of: :ticket_orders
  belongs_to :ticket, inverse_of: :ticket_orders

  scope :active, -> { joins(:ticket).merge(Ticket.active) }
  scope :pending, -> { where(status: 'pending') }
  scope :relevant, -> { where(status: ['pending', 'accepted','delivered']) }
  # This chaining is made explicit in order to use it with ActiveAdmin scope:
  scope :requires_attention, -> { active.pending }

  def change_to_delivered(deliverer)
    self.status = "delivered"
    self.deliverer = deliverer
    self.save
  end

  def refund
    self.status = "refunded"
    self.save
    # TODO send notification email
  end

  def confirm(payment_type)
    self.status = "accepted"
    self.payment_type = payment_type
    self.payment_date = Time.current
    if self.save
      ApplicationMailer.ticket_confirmed_email(self).deliver_now
    end

  end

  def unconfirm
    self.status = "pending"
    self.save
    # TODO send notification email
  end

  def reject
    self.status = "rejected"
    self.save
  end

  def total_price
    self.quantity * self.ticket.price.to_i
  end

  def self.to_csv
    attributes = ['id', 'name', 'quantity', 'total_price', 'status']
    CSV.generate(headers: true) do | csv |
      csv << attributes
      all.each do | ticket_order |
        csv << ["MC" + ticket_order.id.to_s,
                ticket_order.user.name,
                ticket_order.quantity,
                ticket_order.total_price,
                ticket_order.status
        ]
      end
    end
  end

  def status_localized
    return case status
      when "pending"
        I18n.t('ticketing.state_pending')
      when "accepted"
        I18n.t('ticketing.state_accepted')
      when "rejected"
        I18n.t('ticketing.state_rejected')
      when "delivered"
        I18n.t('ticketing.state_delivered')
      when "refunded"
        I18n.t('ticketing.state_refunded')
     end
  end
end

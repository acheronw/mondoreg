class TicketOrder < ApplicationRecord
  validates :status, :inclusion => { :in => ['pending', 'accepted', 'rejected'],
                                     message: "%value is not a valid ticket status" }

  belongs_to :user, inverse_of: :ticket_orders
  belongs_to :ticket, inverse_of: :ticket_orders

  scope :active, -> { joins(:ticket).merge(Ticket.active) }
  scope :pending, -> { where(status: 'pending') }
  scope :relevant, -> { where(status: ['pending', 'accepted']) }
  # This is chaining is made explicit in order to use it with ActiveAdmin scope:
  scope :requires_attention, -> { active.pending }

  def confirm
    self.status = "accepted"
    self.save
    # TODO send notification email with instructions on how to get your ticket at the convention
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

  def status_localized
    return case status
      when "pending"
        I18n.t('ticketing.state_pending')
      when "accepted"
        I18n.t('ticketing.state_accepted')
      when "rejected"
        I18n.t('ticketing.state_rejected')
    end
  end


end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  validates :name, presence: true, length: { maximum: 100 }

  has_many :ticket_orders, inverse_of: :user

  def active_orders
    return TicketOrder.where(user: self).active.all.to_a
  end

  # Only pending tickets of the current event matter.
  def has_any_pending?
    TicketOrder.where(user: self).requires_attention.any?
  end

  # Only pending tickets of the current event matter.
  def has_any_accepted?
    TicketOrder.where(user: self).where(status: 'accepted').any?
  end


end

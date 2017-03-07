class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  validates :name, presence: true, length: { maximum: 100 }

  has_many :ticket_orders, inverse_of: :user, dependent: :destroy
  has_many :comp_applications, inverse_of: :user
  # This is not dependent destroy, because if the user destroys his account, we don't want to lose his application information.
  # For example we use it to keep track of no-shows

  def active_orders
    return TicketOrder.where(user: self).active.all.to_a
  end

  # Only pending tickets of the current event matter.
  def has_any_pending_tickets?
    TicketOrder.where(user: self).requires_attention.any?
  end

  # Only pending tickets of the current event matter.
  def has_any_accepted_tickets?
    TicketOrder.where(user: self).where(status: 'accepted').any?
  end

  def active_applications
    return CompApplication.where(user: self).active.all.to_a
  end

end

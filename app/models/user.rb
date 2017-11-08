class User < ApplicationRecord
  rolify
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

  def competitions_to_apply
    user_already_applied = self.comp_applications.pluck(:competition_id)
    open_comps = Competition.on_sale.where.not(id: user_already_applied).all.to_a
    open_comps.delete_if { | comp | comp.full? }
    return open_comps
  end

  def is_comp_admin?
    has_any_role?( {:name => :manager, :resource => :any},
                   {:name => :assistant, :resource => :any })
  end


end

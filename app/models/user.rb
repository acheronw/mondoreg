class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  validates :name, presence: true, length: { maximum: 100 }
  validates :privacy_accepted, acceptance: true

  has_many :booths, inverse_of: :user
  has_many :comp_applications, inverse_of: :user
  has_many :postages, inverse_of: :user
  has_many :ticket_orders, inverse_of: :user, dependent: :destroy


  # This is not dependent destroy, because if the user destroys his account, we don't want to lose his application information.
  # For example we use it to keep track of no-shows
  has_many :mondo_subscriptions, inverse_of: :user, dependent: :destroy

  scope :active_sub, -> { where ('subscription_uptime > 0') }
  scope :interested_mag, -> { where ('subscription_uptime IS NOT NULL ') }


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


  def competitions_to_apply(show_full = false)
    user_already_applied = self.comp_applications.pluck(:competition_id)
    open_comps = Competition.on_sale.where.not(id: user_already_applied).all.to_a
    unless show_full
      open_comps.delete_if { | comp | comp.full? }
    end
    return open_comps
  end


  def is_comp_admin?
    has_any_role?({:name => :manager, :resource => :any},
                  {:name => :amv_admin, :resource => :any },
				          {:name => :cosplay_admin, :resource => :any },
				          {:name => :karaoke_admin, :resource => :any },
				          {:name => :drawing_admin, :resource => :any })
  end


  def has_subscription_data?
    self.subscription_name.present? && 
      self.subscription_email.present? && 
      self.subscription_zip.present? && 
      self.subscription_city.present? &&
      self.subscription_address.present? 
  end

  def is_vendor?
    self.has_role?(:vendor) ||
        self.has_role?(:vendor1) ||
        self.has_role?(:vendor2) ||
        self.has_role?(:vendor3)
  end

  def self.to_csv
    attributes = ['user_id', 'előfizetett_lapszám', 'előfizető_neve',
                  'előfizetői_email', 'irányítószám',
                  'város', 'cím', 'befizetések']
    CSV.generate(headers: true) do | csv |
      csv << attributes
      all.each do | user |
        payment_details = ""
        user.mondo_subscriptions.where(status: 'accepted').each do | payment |
          payment_details += 'MAG' + payment.id.to_s + ' ' + payment.updated_at.strftime("%F") + " "
        end
        csv << [user.id.to_s,
                user.subscription_uptime,
                user.subscription_name,
                user.subscription_email,
                user.subscription_zip,
                user.subscription_city,
                user.subscription_address,
                payment_details
        ]
      end
    end
  end

end

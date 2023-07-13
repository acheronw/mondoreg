class MondoSubscription < ApplicationRecord
  validates :status, :inclusion => { :in => ['pending', 'accepted'],
                                     message: "%value is not a valid subscription status" }
  validates :user_id, presence: true
  validates :duration, presence: true

  belongs_to :user, inverse_of: :mondo_subscriptions

  def confirm
    self.update!(:status => 'accepted')

    if self.user.subscription_uptime.blank?
      self.user.update!(:subscription_uptime => self.duration)
    else
      self.user.increment!(:subscription_uptime, by = self.duration) 
    end

  end

end
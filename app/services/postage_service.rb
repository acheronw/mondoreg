class PostageService

  def self.create_issue(issue)
    ActiveRecord::Base.transaction do
      MondoSubAttrib.create!(key: "issue", value: issue)
      subscribers = User.active_sub
      subscribers.each do | subscriber |
        Postage.create!(user: subscriber, item: issue)
        subscriber.decrement!(:subscription_uptime)
      end
      subscribers.size
    end
  end


end
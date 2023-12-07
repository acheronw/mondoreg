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

  def self.import(file)
    imported_counter = 0
    not_found_counter = 0
    CSV.foreach(file.path, {headers: true,
                            col_sep: ';'    }) do | row |
      user = User.find_by(email: row["email"])
      if user
        imported_counter += 1
        user.subscription_email = user.email
        user.subscription_name = row["posta_nev"]
        user.subscription_zip  = row["posta_irsz"]
        user.subscription_city = row["posta_varos"]
        user.subscription_address = row["posta_cim"]
        befizeto_id = row[0]
        user.subscription_comment = "befizető azonosító: #{befizeto_id}"
        user.save!
        user.increment!(:subscription_uptime, by=row["duration"].to_i)
      else
        msa = MondoSubAttrib.new(key: "user_not_found", value: row["email"])
        msa.save
        not_found_counter += 1
      end
    end
    "Sikeresen megtaláltunk #{ imported_counter} felhasználót, nem találtunk #{not_found_counter} darabot."
  end


end
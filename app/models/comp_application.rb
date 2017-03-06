class CompApplication < ApplicationRecord
  belongs_to :competition, inverse_of: :comp_applications
  belongs_to :user, inverse_of: :comp_applications

  validates :competition_id, presence: true
  validates :user_id, presence: true
  validates :character_name, presence: true
  validates :character_source, presence: true
  validates :status, presence:true
  validates :status, :inclusion => { :in => ['pending', 'accepted', 'resubmit', 'deleted'],
                                     message: "%value is not a valid ticket status" }

end

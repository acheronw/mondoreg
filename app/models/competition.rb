class Competition < ApplicationRecord
  belongs_to :convention, inverse_of: :competitions
  has_many :comp_applications, inverse_of: :competition

  validates :name, presence: true
  validates :convention_id, presence: true
  validates :subtype, presence: true
  validates :subtype, :inclusion => { :in => ['craft', 'craft_group', 'perf', 'perf_group'],
                                     message: "%value is not a valid competition type" }
  validates :admin_email, presence: true


end

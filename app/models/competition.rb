class Competition < ApplicationRecord
  belongs_to :convention, inverse_of: :competitions
  has_many :comp_applications, inverse_of: :competition

end

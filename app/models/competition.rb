class Competition < ApplicationRecord
  belongs_to :convention, inverse_of: :competitions

  has_many :applications, inverse_of: :competition
end

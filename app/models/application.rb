class Application < ApplicationRecord
  belongs_to :user, inverse_of: :applications
  belongs_to :competition, inverse_of: :applications
end

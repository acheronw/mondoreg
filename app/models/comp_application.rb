class CompApplication < ApplicationRecord
  belongs_to :competition, inverse_of: :comp_applications
  belongs_to :user, inverse_of: :comp_applications
end

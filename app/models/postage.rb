class Postage < ApplicationRecord
  belongs_to :user, inverse_of: :postages

end
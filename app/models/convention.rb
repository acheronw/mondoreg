class Convention < ApplicationRecord

  scope :active, -> { where("relevance_date > ?", Date.today) }

  has_many :tickets, inverse_of: :convention

end

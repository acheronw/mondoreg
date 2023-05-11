class Convention < ApplicationRecord

  scope :active, -> { where("relevance_date > ?", Date.today) }

  has_many :tickets, inverse_of: :convention
  has_many :competitions, inverse_of: :convention
  has_many :booths, inverse_of: :convention

end

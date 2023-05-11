class Booth < ApplicationRecord
  validates :status, :inclusion => { :in => ['submitted', 'confirmed',],
                                     message: "%value is not a valid booth status" }
  validates :user_id, presence: true
  validates :convention_id, presence: true
  validates :booth_number, presence: true
  validates :booth_number, uniqueness: { scope: :convention_id}
  validates :booth_name, presence: true

  belongs_to :user, inverse_of: :booths
  belongs_to :convention, inverse_of: :booths

  scope :active, -> { joins(:convention).merge(Convention.active) }

end

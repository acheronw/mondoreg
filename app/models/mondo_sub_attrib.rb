class MondoSubAttrib < ApplicationRecord

  validates_uniqueness_of :value, scope: :key

  def self.issues(limit = 3)
    return MondoSubAttrib.where(key: "issue").order(created_at: :desc).limit(limit).pluck(:value)
  end



end
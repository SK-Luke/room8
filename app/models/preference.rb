class Preference < ApplicationRecord
  belongs_to :user
  belongs_to :chore

  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true }
  validates :rating, inclusion: { in: 1..3 }
end

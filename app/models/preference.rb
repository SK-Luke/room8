class Preference < ApplicationRecord
  belongs_to :user
  belongs_to :chores

  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true }
  validates :rating, length: { in: 1..3 }
end
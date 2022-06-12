class Preference < ApplicationRecord
  belongs_to :user
  belongs_to :chore

  validates :rating, presence: true, numericality: { only_integer: true }, inclusion: { in: 1..3 }
  validates :chore_id, uniqueness: { scope: :user_id }
end

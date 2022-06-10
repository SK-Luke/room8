class MonthList < ApplicationRecord
  has_many :chore_lists, dependent: :destroy

  validates :month, presence: true
end

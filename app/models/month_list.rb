class MonthList < ApplicationRecord
  has_many :chore_lists

  validates :month, presence: true
end

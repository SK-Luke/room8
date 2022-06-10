class ChoreList < ApplicationRecord
  belongs_to :month_list
  belongs_to :user
  belongs_to :chore

  validates :deadline, presence: true
end

class ChoreList < ApplicationRecord
  belongs_to :month_list
  belongs_to :user
  belongs_to :chores
end

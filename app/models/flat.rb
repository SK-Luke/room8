class Flat < ApplicationRecord
  has_many :users
  has_many :chores

  validates :name, presence: true
end

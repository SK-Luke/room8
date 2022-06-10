class Flat < ApplicationRecord
  has_many :flat_users
  has_many :users, through: :flat_users
  has_many :chores

  validates :name, presence: true
end

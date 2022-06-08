class Flat < ApplicationRecord
  has_many :users, through: :flat_users
  has_many :chores
end

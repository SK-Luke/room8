class Flat < ApplicationRecord
  has_many :flat_users, dependent: :destroy
  has_many :users, through: :flat_users
  has_many :chores, dependent: :destroy

  validates :name, presence: true
end

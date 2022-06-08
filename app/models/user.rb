class User < ApplicationRecord
  has_many :flats, through: :flat_users
  has_many :chore_lists
  has_many :chores, through: :preferences

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

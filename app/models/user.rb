class User < ApplicationRecord
  has_many :flat_users, dependent: :destroy
  has_many :flats, through: :flat_users
  has_many :chore_lists, dependent: :destroy
  has_many :chores, through: :preferences

  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

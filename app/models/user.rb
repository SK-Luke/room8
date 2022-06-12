class User < ApplicationRecord
  has_many :flat_users, dependent: :destroy
  has_many :flats, through: :flat_users
  has_many :chore_lists, dependent: :destroy
  has_many :chores, through: :preferences

  validates :name, :email, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def create_pref_for_all_chores
    chores = flat_users.where(active: true)[0].flat.chores
    chores.each do |chore|
      Preference.create(rating: 2, user_id: id, chore_id: chore.id)
    end
  end
end

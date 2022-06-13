class User < ApplicationRecord
  has_many :flat_users, dependent: :destroy
  has_many :flats, through: :flat_users
  has_many :chore_lists, dependent: :destroy
  has_many :chores, through: :preferences
  has_many :preferences
  has_one_attached :photo

  validates :name, :email, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def create_pref_for_all_chores!
    flat_chores = flat_users.where(active: true)[0].flat.chores
    flat_chores.each do |chore|
      Preference.create(rating: 2, user_id: id, chore_id: chore.id)
    end
  end

  def list_flat_chores
    flat_users.where(active: true)[0].flat.chores
  end

  def pref_not_exist_for_chore?(chore)
    preferences.where(chore_id: chore.id).empty?
  end

  def find_chores_where_pref_not_exist
    flat_chores = flat_users.where(active: true)[0].flat.chores
    flat_chores.select { |chore| preferences.map(&:chore_id).exclude? chore.id }
  end

  def create_pref_for_chores(chores_array)
    chores_array.each do |chore|
      Preference.create(rating: 2, user_id: id, chore_id: chore.id)
    end
  end
end

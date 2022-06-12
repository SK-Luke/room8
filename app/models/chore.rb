class Chore < ApplicationRecord
  belongs_to :flat
  has_many :preferences # WX: wanted to dependent destroy but it causes problems when trying to destroy the chore if no dep i think

  validates :name, :frequency, :repetition, :duration, presence: true
  validates :repetition, numericality: { greater_than: 0 }
  validates :frequency, inclusion: { in: %w(daily weekly monthly) }

  def create_pref_for_all_users
    flat_users = flat.flat_users.where(active: true)
    flat_users.each do |user|
      Preference.create(rating: 2, user_id: user.id, chore_id: id)
    end
  end

  def pref_not_exist_for_user?(user)
    preferences.where(user_id: user.id).empty?
  end

  def self.create_defaults(flat_id)
    Chore.create(
      name: "Take out trash",
      frequency: "weekly",
      repetition: 3,
      duration: 5,
      flat_id: flat_id
    )
    Chore.create(
      name: "Clean the toilet",
      frequency: "weekly",
      repetition: 1,
      duration: 60,
      flat_id: flat_id
    )
    Chore.create(
      name: "Sweep living room",
      frequency: "weekly",
      repetition: 1,
      duration: 20,
      flat_id: flat_id
    )
    Chore.create(
      name: "Mop living room",
      frequency: "weekly",
      repetition: 1,
      duration: 20,
      flat_id: flat_id
    )
    Chore.create(
      name: "Clean fridge",
      frequency: "monthly",
      repetition: 1,
      duration: 20,
      flat_id: flat_id
    )
    Chore.create(
      name: "Clean blinds",
      frequency: "monthly",
      repetition: 1,
      duration: 20,
      flat_id: flat_id
    )
    Chore.create(
      name: "Dust living room",
      frequency: "weekly",
      repetition: 1,
      duration: 30,
      flat_id: flat_id
    )
  end
end

class Chore < ApplicationRecord
  belongs_to :flat
  has_many :preferences, dependent: :destroy

  validates :name, :frequency, :repetition, presence: true
  validates :repetition, numericality: { greater_than: 0 }
  validates :frequency, inclusion: { in: %w(daily weekly monthly) }

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

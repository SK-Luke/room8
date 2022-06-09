class Chore < ApplicationRecord
  belongs_to :flat

  validates :name, :frequency, :reptition, presence: true
  validates :repetition, numericality: { greater_than: 0 }
  validates :frequency, inclusion: { in: %w(daily weekly monthly) }
end

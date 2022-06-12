class FlatUser < ApplicationRecord
  belongs_to :user
  belongs_to :flat

  validates :flat, uniqueness: { scope: :user_id, message: "User already exists for this flat."}
end

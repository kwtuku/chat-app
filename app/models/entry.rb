class Entry < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :room_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
end

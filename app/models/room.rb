class Room < ApplicationRecord
  enum room_type: { direct: 0, group: 1 }, _suffix: :chat

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :users, through: :entries

  validates :name, presence: true
  validates :room_type, inclusion: { in: %w[direct group] }, presence: true
  validates :slug, presence: true, uniqueness: true
end

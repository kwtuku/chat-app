class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries

  def create_room_with(other_user)
    raise 'Invalid argument' if other_user == self

    new_room = rooms.create!
    other_user.entries.create!(room_id: new_room.id)
    new_room
  end
end

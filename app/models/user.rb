class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries

  def find_or_create_direct_chat_with(other_user)
    raise 'Invalid argument' if other_user == self

    slug = [self, other_user].map(&:id).sort.join('-')
    room = Room.find_by(slug: slug)
    room || create_direct_chat_with(other_user, slug)
  end

  def create_direct_chat_with(other_user, slug)
    new_room = rooms.create!(name: other_user.id, room_type: 'direct', slug: slug)
    other_user.entries.create!(room_id: new_room.id)
    new_room
  end
end

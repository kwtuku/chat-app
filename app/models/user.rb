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

  def create_group_chat_with(other_users)
    raise 'Invalid argument' if other_users.class != Array

    other_users.uniq!
    other_users.delete(self)

    users = other_users + [self]
    name = users.map(&:id).sort.join(', ')
    slug = SecureRandom.hex
    new_room = rooms.create!(name: name, room_type: 'group', slug: slug)
    other_users.each { |user| user.entries.create!(room_id: new_room.id) }
    new_room
  end
end

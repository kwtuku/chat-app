class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries

  mount_uploader :avatar, AvatarUploader

  validates :name, presence: true, length: { maximum: 30 }

  def find_or_create_direct_chat_with(other_user)
    raise 'Invalid argument' if other_user == self

    slug = [self, other_user].map(&:id).sort.join('-')
    room = Room.find_by(slug: slug)
    room || create_direct_chat_with(other_user, slug)
  end

  def create_direct_chat_with(other_user, slug)
    name = [self, other_user].map(&:name).sort.join(', ')
    new_room = rooms.create!(name: name, room_type: 'direct', slug: slug)
    other_user.entries.create!(room_id: new_room.id)
    new_room
  end

  def create_group_chat_with(other_users)
    users = other_users.to_a + [self]
    name = users.map(&:name).sort.join(', ')
    slug = SecureRandom.hex
    new_room = rooms.create!(name: name, room_type: 'group', slug: slug)
    other_users.each { |user| user.entries.find_or_create_by(room_id: new_room.id) }
    new_room
  end
end

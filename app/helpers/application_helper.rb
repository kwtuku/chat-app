module ApplicationHelper
  def message_created_at(created_at)
    if created_at > Time.current.yesterday
      l created_at, format: :today
    elsif created_at > Time.current.last_year
      l created_at, format: :this_year
    else
      l created_at, format: :before_this_year
    end
  end

  def other_user(room, user)
    (room.users - [user]).first
  end

  def room_image_url(room, user)
    if room.room_type == 'direct'
      other_user(room, user).avatar.icon.url
    else
      'https://placehold.jp/150x150.png'
    end
  end

  def room_name(room, user)
    if room.room_type == 'direct'
      other_user(room, user).name
    else
      room.name
    end
  end
end

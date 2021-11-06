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

  def other_user_avatar(users)
    other_user = (users - [current_user]).first
    image_tag other_user.avatar.icon.url, class: 'img-fluid rounded-circle'
  end
end

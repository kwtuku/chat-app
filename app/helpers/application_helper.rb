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
end

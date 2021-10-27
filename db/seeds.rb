Rails.logger = Logger.new($stdout)

ApplicationRecord.transaction do
  3.times do |n|
    User.find_or_create_by!(email: "example#{n + 1}@example.com") { |user| user.password = 'fffffr' }
  end
  Rails.logger.debug 'userを作成'

  room = Room.create!
  Rails.logger.debug 'roomを作成'

  user_ids = User.ids

  user_ids.each do |user_id|
    Entry.create!(room_id: room.id, user_id: user_id)
  end
  Rails.logger.debug 'entryを作成'

  user_ids.each do |user_id|
    Message.create!(
      room_id: room.id,
      user_id: user_id,
      content: Faker::Lorem.paragraphs(number: rand(1..4)).join("\n")
    )
  end
  Rails.logger.debug 'messageを作成'

  room_without_msg = Room.create!
  Rails.logger.debug 'room_without_msgを作成'

  user_ids.each do |user_id|
    Entry.create!(room_id: room_without_msg.id, user_id: user_id)
  end
  Rails.logger.debug 'entryを作成'
end

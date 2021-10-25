Rails.logger = Logger.new($stdout)

user_count = 3
message_count = 1000

ApplicationRecord.transaction do
  user_count.times do |n|
    User.find_or_create_by!(email: "test#{n + 1}@example.com") do |user|
      user.password = 'password'
    end
  end

  Message.destroy_all
  user_ids = User.ids
  message_list = []
  message_count.times do
    user_id = user_ids.sample
    line_count = rand(1..4)
    content = Faker::Lorem.paragraphs(number: line_count).join("\n")
    message_list << { user_id: user_id, content: content }
  end
  Message.create!(message_list)
end
Rails.logger.debug '初期データの追加が完了しました！'

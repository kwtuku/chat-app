class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  def template
    ApplicationController.render_with_signed_in_user(user, partial: 'messages/message', locals: { message: self })
  end
end

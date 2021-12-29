class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  def partial_for_current_user
    ApplicationController.renderer.render(partial: 'messages/current_user_message', locals: { message: self })
  end

  def partial_for_other_user
    ApplicationController.renderer.render(partial: 'messages/other_user_message', locals: { message: self })
  end
end

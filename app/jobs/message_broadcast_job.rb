class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast(
      'room_channel',
      message_user_id: message.user_id,
      message: render_current_user_message(message),
      other_user_message: render_other_user_message(message)
    )
  end

  private

  def render_current_user_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/current_user_message',
      locals: {
        message: message,
      },
    )
  end

  def render_other_user_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/other_user_message',
      locals: {
        message: message,
      },
    )
  end
end

class MessagesController < ApplicationController
  after_action :verify_authorized

  def create
    @message = current_user.messages.new(message_params)
    @message.room_id = params[:room_id]
    authorize @message
    @message.save
    ActionCable.server.broadcast 'room_channel', message_user_id: @message.user_id, message: @message.partial_for_current_user, other_user_message: @message.partial_for_other_user
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

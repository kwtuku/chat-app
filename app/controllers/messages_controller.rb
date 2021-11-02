class MessagesController < ApplicationController
  def create
    @message = current_user.messages.new(message_params)
    @message.room_id = params[:room_id]
    @message.save
    ActionCable.server.broadcast 'room_channel', message: @message.template
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

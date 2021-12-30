class MessagesController < ApplicationController
  after_action :verify_authorized

  def create
    @message = current_user.messages.new(message_params)
    @message.room_id = params[:room_id]
    authorize @message
    @message.save
    MessageBroadcastJob.perform_later(@message)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

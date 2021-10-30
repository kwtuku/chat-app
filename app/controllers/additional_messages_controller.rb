class AdditionalMessagesController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
    first = params[:message_count].to_i
    last = first + 49
    @messages = @room.messages.includes(:user).order(id: :DESC)[first..last].reverse
  end
end

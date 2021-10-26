class RoomsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @rooms = current_user.rooms.all if user_signed_in?
  end

  def show
    @rooms = current_user.rooms.all
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user).order(:id).last(100)
    @message = current_user.messages.build
  end

  def show_additionally
    last_id = params[:oldest_message_id].to_i - 1
    @messages = Message.includes(:user).order(:id).where(id: 1..last_id).last(50)
  end
end

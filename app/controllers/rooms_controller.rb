class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms.all
  end

  def show
    @rooms = current_user.rooms.all
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user).order(:id).last(50)
    @message = current_user.messages.build
  end
end

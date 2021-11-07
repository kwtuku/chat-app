class RoomsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize User
    @rooms = current_user.rooms.all
  end

  def show
    @room = Room.find(params[:id])
    authorize @room
    @rooms = current_user.rooms.all
    @messages = @room.messages.includes(:user).order(:id).last(50)
    @message = current_user.messages.build
  end
end

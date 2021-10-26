class EntriesController < ApplicationController
  def create
    other_user = User.find(params[:user_id])
    room = current_user.create_room_with(other_user)

    redirect_to room_path(room)
  end
end

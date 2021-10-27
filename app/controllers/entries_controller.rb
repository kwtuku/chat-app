class EntriesController < ApplicationController
  def create
    other_user = User.find(params[:user_id])

    redirect_to request.referer || root_path, alert: 'この操作は実行できません。' and return if other_user == current_user

    room = current_user.create_room_with(other_user)
    redirect_to room_path(room)
  end
end

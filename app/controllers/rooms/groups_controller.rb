module Rooms
  class GroupsController < ApplicationController
    def new
      @other_users = User.all - [current_user]
    end

    def create
      other_users = User.where(id: params[:user_ids])

      if other_users.blank?
        @other_users = User.all - [current_user]
        flash.now[:alert] = '入力に問題があります。'
        render :new
      elsif other_users == [current_user]
        @other_users = User.all - [current_user]
        flash.now[:alert] = 'この操作は実行できません。'
        render :new
      else
        room = current_user.create_group_chat_with(other_users)
        redirect_to room_path(room)
      end
    end
  end
end

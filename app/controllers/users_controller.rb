class UsersController < ApplicationController
  def index
    @other_users = User.all - [current_user]
  end
end

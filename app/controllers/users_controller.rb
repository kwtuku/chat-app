class UsersController < ApplicationController
  after_action :verify_authorized

  def index
    authorize User
    @other_users = User.all - [current_user]
  end
end

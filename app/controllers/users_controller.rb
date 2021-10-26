class UsersController < ApplicationController
  def index
    @users = User.all
    @entry = Entry.new
  end
end

class RoomPolicy < ApplicationPolicy
  def index?
    user
  end
end

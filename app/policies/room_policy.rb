class RoomPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    record.users.include?(user)
  end
end

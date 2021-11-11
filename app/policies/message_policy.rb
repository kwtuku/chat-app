class MessagePolicy < ApplicationPolicy
  def create?
    record.room.users.include?(user)
  end
end

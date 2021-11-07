class AdditionalMessagePolicy < ApplicationPolicy
  def index?
    record.users.include?(user)
  end
end

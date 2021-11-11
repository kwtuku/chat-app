class UserPolicy < ApplicationPolicy
  def index?
    user
  end
end

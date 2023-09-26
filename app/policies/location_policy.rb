class LocationPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    user.admin?
  end

  def update?
    edit?
  end
end

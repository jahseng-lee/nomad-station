class IssuePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    record.reporter == user
  end

  def update?
    index?
  end
end

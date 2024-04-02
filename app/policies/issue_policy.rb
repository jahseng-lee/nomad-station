class IssuePolicy < ApplicationPolicy
  def create?
    record.reporter == user
  end
end

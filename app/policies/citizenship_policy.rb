class CitizenshipPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
end

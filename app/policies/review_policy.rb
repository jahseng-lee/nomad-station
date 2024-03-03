class ReviewPolicy < ApplicationPolicy
  def show?
    true
  end

  def new?
    true
  end

  def create?
    record.user == user
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end
end

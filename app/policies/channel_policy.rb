class ChannelPolicy < ApplicationPolicy
  def show?
    user.admin? || user.active_subscription?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end
end

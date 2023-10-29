class ChannelPolicy < ApplicationPolicy
  def new?
    user.admin?
  end
end

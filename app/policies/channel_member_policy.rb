class ChannelMemberPolicy < ApplicationPolicy
  def destroy?
    record.user == user
  end
end

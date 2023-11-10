class ChannelMemberPolicy < ApplicationPolicy
  def destroy?
    record.user == user
  end

  def update_last_active?
    record.user == user
  end
end

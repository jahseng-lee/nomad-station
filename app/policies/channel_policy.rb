class ChannelPolicy < ApplicationPolicy
  def show?
    user.admin? ||
      record.channel_members.find_by(user_id: user.id).present?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end
end

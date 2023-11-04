class ChannelMessagePolicy < ApplicationPolicy
  def create?
    record.channel.channel_members.find_by(user_id: user.id).present? &&
      record.sender == user
  end
end

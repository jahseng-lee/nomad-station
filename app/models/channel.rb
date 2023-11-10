class Channel < ApplicationRecord
  DEFAULT_CHAT_CHANNELS = [
    "General",
    "Feedback and requests",
    "Bugs"
  ]

  validates :name, presence: true

  has_many :channel_members
  has_many :messages, class_name: "ChannelMessage"

  def include?(user:)
    channel_members.find_by(user_id: user.id).present?
  end
end

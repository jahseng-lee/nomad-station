class Channel < ApplicationRecord
  DEFAULT_CHAT_CHANNELS = [
    "General",
    "Feedback and requests",
    "Bugs"
  ]

  validates :name, presence: true, uniqueness: true

  has_many :channel_members
  has_many :messages, class_name: "ChannelMessage"

  def self.default_channels
    Channel.where(name: DEFAULT_CHAT_CHANNELS)
  end

  def include?(user:)
    user &&
      channel_members.find_by(user_id: user.id).present?
  end

  def latest_message
    messages.order(:created_at).last
  end
end

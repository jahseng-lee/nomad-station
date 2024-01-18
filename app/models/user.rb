class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :trackable and :omniauthable
  devise :confirmable,
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  has_many :channel_members
  has_many :chat_channels,
    through: :channel_members
  has_one :profile_picture
  has_many :reviews

  validates :display_name,
    length: { minimum: 5, maximum: 50 },
    uniqueness: true

  def subscription_status
    if self[:subscription_status].present?
      self[:subscription_status].capitalize
    elsif self.stripe_customer_id.nil?
      "None"
    end
  end

  def active_subscription?
    self.admin? ||
      self[:subscription_status] == "active" ||
      self[:subscription_status] == "trialing"
  end

  def cancelled_subscription?
    !self.admin? &&
      self[:subscription_status] == "canceled"
  end

  def no_subscription?
    !self.admin? &&
      self[:subscription_status].nil?
  end

  def unread_channel_count
    channel_members
      .joins(:chat_channel)
      .where("channel_members.last_active < channels.last_action_at")
      .count
  end

  def unread_message_count(channel:)
    member = channel.channel_members.find_by(user_id: self[:id])

    return 0 if member.nil?

    channel
      .messages
      .where("created_at > ?", member.last_active)
      .count
  end
end

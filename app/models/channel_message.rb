class ChannelMessage < ApplicationRecord
  belongs_to :channel
  belongs_to :sender,
    foreign_key: :user_id,
    class_name: "User"
  belongs_to :reply_to,
    foreign_key: :reply_to_id,
    class_name: "ChannelMessage",
    optional: true

  validates :body, presence: true

  def body
    deleted? ? "Deleted message" : self[:body]
  end

  def sender?(user:)
    @sender ||= user.present? && user == self[:sender]
  end
end

class Channel < ApplicationRecord
  DEFAULT_CHAT_CHANNELS = [
    "General",
    "Feedback and requests",
    "Bugs"
  ]

  validates :name, presence: true

  has_many :channel_members
end

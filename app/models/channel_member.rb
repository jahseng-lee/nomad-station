class ChannelMember < ApplicationRecord
  belongs_to :chat_channel,
    foreign_key: :channel_id,
    class_name: "Channel"
  belongs_to :user
end

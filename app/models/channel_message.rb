class ChannelMessage < ApplicationRecord
  belongs_to :channel
  belongs_to :sender,
    foreign_key: :user_id,
    class_name: "User"
end

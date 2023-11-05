class ChannelMessage < ApplicationRecord
  belongs_to :channel
  belongs_to :sender,
    foreign_key: :user_id,
    class_name: "User"

  validates :body, presence: true

  def body
    deleted? ? "Deleted message" : self[:body]
  end
end

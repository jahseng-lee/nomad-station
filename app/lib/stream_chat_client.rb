require "stream-chat"

class StreamChatClient
  def self.add_member(channel:, user_id:)
    channel.add_members([user_id])
  end

  def self.channel_include?(channel:, user_id:)
    #channel.query_members(
    #  filter_conditions: { id: { "$in" => [user_id] } }
    #)["members"].any?

    # TODO the filter_conditions above doesn't work
    #      this is much slower but for some reason query_members,
    #      regardless of user_id, always returns all users
    members = channel.query_members()["members"]
    members.map{ |member| member["user_id"] }.include?(user_id)
  end

  def self.get_channel(type:, channel_id:)
    client.channel(type, channel_id: channel_id)
  end

  def self.create_stream_user(id:)
    client.create_token(id)
  end

  private

  def self.client
    StreamChat::Client.new(
      api_key=ENV["STREAM_API_KEY"],
      api_secret=ENV["STREAM_API_SECRET"]
    )
  end
end

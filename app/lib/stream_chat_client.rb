class StreamChatClient
  def create_stream_user(id:)
    client.create_token(id)
  end

  private

  def client
    StreamChat::Client.new(
      api_key=ENV["STREAM_API_KEY"],
      api_secret=ENV["STREAM_API_SECRET"]
    )
  end
end

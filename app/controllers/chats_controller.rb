require "securerandom"

class ChatsController < ApplicationController
  layout false, only: [:show]

  def show
    if current_user.stream_user_id.nil?
      @stream_user_id = SecureRandom.hex(16)
      @stream_user_token = StreamChatClient.create_stream_user(
        id: @stream_user_id
      )

      # TODO error handling
      current_user.update!(
        stream_user_id: @stream_user_id,
        stream_user_token: @stream_user_token
      )
    else
      @stream_user_id = current_user.stream_user_id
      @stream_user_token = current_user.stream_user_token
    end

    add_current_user_to_channels
  end

  private

  def add_current_user_to_channels
    [
      { type: "messaging", id: "general" },
      { type: "messaging", id: "feedback-and-requests" },
    ].each do |channel|
      channel = StreamChatClient.get_channel(
        type: channel[:type],
        channel_id: channel[:id],
      )
      unless StreamChatClient.channel_include?(
          channel: channel,
          user_id: current_user.stream_user_id
      )
        StreamChatClient.add_member(
          channel: channel,
          user_id: current_user.stream_user_id
        )
      end
    end
  end
end

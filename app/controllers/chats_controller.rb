require "securerandom"

class ChatsController < ApplicationController
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
  end
end

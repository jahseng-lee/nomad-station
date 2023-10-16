class ChatsController < ApplicationController
  def show
    if current_user.stream_user_id.nil?
      # TODO create stream user
    else
      @stream_user_id = current_user.stream_user_id
      @stream_user_token = current_user.stream_user_token
    end
  end
end

require "securerandom"

class ChatsController < ApplicationController
  layout false, only: [:show]

  before_action :authenticate_subscription!, only: [:show]

  def show
    add_user_to_default_channels

    @channels = current_user.chat_channels
  end

  def navbar_link
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "navbar-chat-link",
          partial: "layouts/navbar/chat_link",
          locals: {
            user: current_user
          }
        )
      end
    end
  end

  private

  def add_user_to_default_channels
    if current_user.chat_channels.empty?
      Channel::DEFAULT_CHAT_CHANNELS.each do |channel_name|
        ChannelMember.create!(
          chat_channel: Channel.find_by!(name: channel_name),
          user: current_user
        )
      end
    end
  end
end

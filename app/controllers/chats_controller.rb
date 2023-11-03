require "securerandom"

class ChatsController < ApplicationController
  layout false, only: [:show]

  before_action :authenticate_subscription!

  def show
    add_user_to_default_channels

    @channels = current_user.chat_channels
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

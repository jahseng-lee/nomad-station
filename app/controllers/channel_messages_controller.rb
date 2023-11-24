class ChannelMessagesController < ApplicationController
  include Pagy::Backend

  def index
    @channel = Channel.find(params[:channel_id])

    authorize(@channel, :show?)

    @pagy, @messages = pagy(
      @channel.messages.order(created_at: :desc),
      items: 50,
      page: params[:page]
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          "channel-messages",
          partial: "channels/chat_messages",
          locals: {
            messages: @messages,
            channel: @channel,
            user: current_user
          }
        )
      end
    end
  rescue Pagy::OverflowError
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "load-more-link",
          partial: "channels/start_of_conversation"
        )
      end
    end
  end

  def create
    @channel = Channel.find(params[:channel_id])
    @message = ChannelMessage.new(
      body: channel_message_params[:body],
      reply_to_id: channel_message_params[:reply_to_id],
      sender: current_user,
      channel: @channel
    )

    authorize(@message)

    if @message.save
      # Update channel member
      ChannelMember
        .find_by!(
          user: current_user,
          chat_channel: @channel
        )
        .update!(
          last_active: Time.now
        )

      # Update channel activity
      @channel.update!(last_action_at: Time.now)

      # Update users of the channel
      # NOTE this should probably be a background job
      @channel.channel_members.each do |channel_member|
        user = channel_member.user
        next if current_user == user

        Turbo::StreamsChannel.broadcast_action_to(
          "user-#{channel_member.user_id}-navbar-chat-link",
          action: :replace,
          target: "navbar-chat-link",
          partial: "layouts/navbar/chat_link",
          locals: {
            user: user,
          }
        )

        Turbo::StreamsChannel.broadcast_action_to(
          "user-#{channel_member.user_id}-chat",
          action: :replace,
          target: "channel-list",
          partial: "chats/current_user_channel_list",
          locals: {
            user: user,
          }
        )

        Turbo::StreamsChannel.broadcast_action_to(
          "user-#{channel_member.user_id}-channel-#{@channel.id}",
          action: :append,
          target: "channel-messages",
          partial: "channels/chat_message",
          locals: {
            message: @message,
            channel: @channel,
            user: user
          }
        )
      end
    end

    # If message.save fails, the partial handles the error messaging
    # Else just re-render the section and show the sent message
    respond_to do |format|
      @messages = @channel.messages.order(created_at: :desc).limit(50)

      format.turbo_stream
    end
  end

  def destroy
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.find_by!(
      id: params[:id],
      channel: @channel
    )

    authorize(@message)

    @message.update!(deleted: true)

    @channel.channel_members.each do |channel_member|
      user = channel_member.user
      next if current_user == user

      Turbo::StreamsChannel.broadcast_action_to(
        "user-#{channel_member.user_id}-channel-#{@channel.id}",
        action: :replace,
        target: "chat-message-#{@message.id}",
        partial: "channels/chat_message",
        locals: {
          message: @message,
          channel: @channel,
          user: user
        }
      )
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "chat-message-#{@message.id}",
          partial: "channels/chat_message",
          locals: {
            message: @message,
            channel: @channel,
            user: current_user
          }
        )
      end
    end
  end

  private

  def channel_message_params
    params.require(:channel_message).permit(
      :body,
      :reply_to_id
    )
  end
end

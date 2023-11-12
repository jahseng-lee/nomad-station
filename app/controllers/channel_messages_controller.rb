class ChannelMessagesController < ApplicationController
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
        Turbo::StreamsChannel.broadcast_action_to(
          "user-#{channel_member.user_id}-navbar-chat-link",
          action: :replace,
          target: "navbar-chat-link",
          partial: "layouts/navbar/chat_link",
          locals: {
            user: channel_member.user
          }
        )
      end

      # TODO use turbo_stream and cable to update other users, including:
      #      * their messages
      #      * the relevant channels on the channel list
      #      * the navbar
      #      This should probably be a background task using sidekiq
    end

    # If message.save fails, the partial handles the error messaging
    # Else just re-render the section and show the sent message
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "chat-channel",
          partial: "channels/chat_message_section",
          locals: { channel: @channel, message: ChannelMessage.new }
        )
      end
    end
  end

  def destroy
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.find_by!(
      id: params[:id],
      sender: current_user,
      channel: @channel
    )

    authorize(@message)

    @message.update!(deleted: true)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "chat-message-#{@message.id}",
          partial: "channels/chat_message",
          locals: {
            message: @message,
            channel: @channel
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

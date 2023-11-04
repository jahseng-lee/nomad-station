class ChannelMessagesController < ApplicationController
  def create
    @channel = Channel.find(params[:channel_id])
    @message = ChannelMessage.new(
      body: channel_message_params[:body],
      sender: current_user,
      channel: @channel
    )

    authorize(@message)

    if @message.save
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
          locals: { channel: @channel, message: @message }
        )
      end
    end
  end

  def update
    raise NotImplementedError, "TODO"
  end

  private

  def channel_message_params
    params.require(:channel_message).permit(:body)
  end
end

class ChannelsController < ApplicationController
  layout false, only: [:show]

  def show
    @channel = Channel.find(params[:id])

    authorize(@channel)

    @channels = current_user.chat_channels

    render "chats/show"
  end

  def new
    @channel = Channel.new

    authorize(@channel)
  end

  def create
    @channel = Channel.new(channel_params)

    authorize(@channel)

    if @channel.save
      redirect_to chat_path
    else
      flash[:error_create_channel] = "Couldn't create channel right now. Please try again"

      render :new
    end
  end

  private

  def channel_params
    params.require(:channel).permit(
      :name
    )
  end
end

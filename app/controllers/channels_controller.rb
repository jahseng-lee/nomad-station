class ChannelsController < ApplicationController
  include Pagy::Backend

  layout false, only: [:show]

  def show
    @channel = Channel.find(params[:id])

    authorize(@channel)

    @channels = current_user.chat_channels
    @messages = @channel.messages.order(created_at: :desc).limit(50)
    @message = ChannelMessage.new

    if @channel.include?(user: current_user)
      # NOTE this should probably be a background job
      @channel
        .channel_members
        .find_by!(user: current_user)
        .update!(last_active: Time.now)

      Turbo::StreamsChannel.broadcast_action_to(
        "user-#{current_user}-navbar-chat-link",
        action: :replace,
        target: "navbar-chat-link",
        partial: "layouts/navbar/chat_link",
        locals: {
          user: current_user
        }
      )
    end

    render "chats/show"
  end

  def new
    @channel = Channel.new

    authorize(@channel)
  end

  def create
    @channel = Channel.new(
      channel_params.merge({
        last_action_at: Time.now
      }),
    )

    authorize(@channel)

    if @channel.save
      # Add the admin who created the channel to it
      ChannelMember.create!(
        user: current_user,
        chat_channel: @channel
      )

      redirect_to chat_path
    else
      flash[:error_create_channel] = "Couldn't create channel right now. Please try again"

      render :new
    end
  end

  def joinable
    # TODO the query below isn't working - so write a less
    # efficient query for now
    #@channels = Channel
    #  .left_joins(:channel_members)
    #  .where.not(channel_members: { user_id: current_user.id })
    current_user_channels = Channel
      .joins(:channel_members)
      .where("channel_members.user_id = ?", current_user.id)
      .pluck(:id)

    @channels = Channel
      .where(id: Channel.pluck(:id) - current_user_channels)
      .order(:last_action_at)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def current_user_list
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def channel_params
    params.require(:channel).permit(
      :name
    )
  end
end

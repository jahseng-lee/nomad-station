class ChannelMembersController < ApplicationController
  def create
    @channel = Channel.find(create_channel_member_params[:channel_id])
    @user = User.find(create_channel_member_params[:user_id])

    @member = ChannelMember.new(
      chat_channel: @channel,
      user: @user
    )

    if @member.save
      redirect_to @channel
    else
      flash[:error_join_channel] = "Couldn't join channel at this time. Please try again"

      redirect_to @channel
    end
  end

  def destroy
    @member = ChannelMember.find(params[:id])

    authorize(@member)
    @member.destroy!

    redirect_to chat_path
  end

  def update_last_active
    @member = ChannelMember.find(params[:id])

    authorize(@member)

    previous_last_active = @member.last_active
    @member.update!(last_active: Time.now)

    respond_to do |format|
      format.turbo_stream do
        if previous_last_active < @member.chat_channel.last_action_at
          render turbo_stream: turbo_stream.replace(
            "channel-list",
            partial: "chats/current_user_channel_list",
            locals: {
              user: current_user
            }
          )
        end
      end
    end
  end

  private

  def create_channel_member_params
    params.require(:channel_member).permit(
      :channel_id,
      :user_id
    )
  end
end

class ChannelMembersController < ApplicationController
  def create
    @channel = Channel.find(channel_member_params[:channel_id])
    @user = User.find(channel_member_params[:user_id])

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

  private

  def channel_member_params
    params.require(:channel_member).permit(
      :channel_id,
      :user_id
    )
  end
end

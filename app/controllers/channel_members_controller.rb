class ChannelMembersController < ApplicationController
  def destroy
    @member = ChannelMember.find(params[:id])

    authorize(@member)
    @member.destroy!

    redirect_to chat_path
  end
end

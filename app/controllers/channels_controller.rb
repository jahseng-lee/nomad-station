class ChannelsController < ApplicationController
  def new
    @channel = Channel.new

    authorize(@channel)
  end

  def create
    raise NotImplementedError, "TODO"
  end
end

require "securerandom"

class ChatsController < ApplicationController
  layout false, only: [:show]

  before_action :authenticate_subscription!

  def show; end
end

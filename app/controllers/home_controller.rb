class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @locations = Location.all.limit(50)
  end
end

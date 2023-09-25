class HomeController < ApplicationController
  def index
    @locations = Location.all.limit(50)
  end
end

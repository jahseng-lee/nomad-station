class LocationsController < ApplicationController
  def show
    @location = Location.find(params[:id])
  end

  def edit
    raise NotImplementedError, "TODO"
  end
end

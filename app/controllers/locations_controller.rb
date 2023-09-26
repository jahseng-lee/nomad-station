class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @location = Location.find(params[:id])
  end

  def edit
    @location = Location.find(params[:id])
    authorize(@location)
  end

  def update
    @location = Location.find(params[:id])
    authorize(@location)

    @location.assign_attributes(location_params)

    if @location.save
      flash[:success_update_location] = "Updated location"

      redirect_to @location
    else
      flash[:error_update_location] = "Couldn't update location. Please try again"
      render :edit
    end
  end

  private

  def location_params
    params.require(:location).permit(:description)
  end
end

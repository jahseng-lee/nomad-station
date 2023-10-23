class VisaInformationController < ApplicationController
  def show
    @location = Location.find(params[:location_id])
  end
end

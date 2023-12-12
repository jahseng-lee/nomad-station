class VisaInformationController < ApplicationController
  before_action :authenticate_subscription!
  before_action :initialize_markdown_renderer, only: :show

  def show
    @location = Location.find(params[:location_id])
    @country = @location.country
  end

  def edit
    @location = Location.find(params[:location_id])
    @country = @location.country

    authorize(@location, :edit?)
  end
end

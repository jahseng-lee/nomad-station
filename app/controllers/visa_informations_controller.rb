class VisaInformationsController < ApplicationController
  before_action :initialize_markdown_renderer
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @location = Location.find(params[:location_id])

    if current_user && current_user.citizenships.any?
      @visa_information = VisaInformation.find_by(
        country_id: @location.country.id,
        # Assume only one citizenship for now
        citizenship_id: current_user.citizenships.first.country.id
      )
    end

    if @visa_information.nil?
      @visa_information = VisaInformation.generic(
        country: @location.country
      )
    end
  end
end

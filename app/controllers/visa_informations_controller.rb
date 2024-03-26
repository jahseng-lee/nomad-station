class VisaInformationsController < ApplicationController
  before_action :initialize_markdown_renderer
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @location = Location.find(params[:location_id])

    # TODO add user_citizenships table
    #if current_user && current_user.citizenships.any?
    #end
    @visa_information = VisaInformation.generic(
      country: @location.country
    )
  end
end

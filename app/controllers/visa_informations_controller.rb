class VisaInformationsController < ApplicationController
  before_action :initialize_markdown_renderer
  skip_before_action :authenticate_user!, only: [:show, :content]

  def show
    @location = Location.find(params[:location_id])
  end

  def content
    @location = Location.find(params[:location_id])

    if current_user.nil? || current_user.citizenship.nil?
      @visa_information = VisaInformation.generic(
        country: @location.country
      )
    else
      citizenship_country = current_user.citizenship.country
      @visa_information = VisaInformation.find_by(
        country: @location.country,
        # Assume only one citizenship for now
        citizenship: citizenship_country
      )

      # Couldn't find VisaInformation for the @location.country and the
      # current_user.citizenship.country - create one instead
      if @visa_information.nil?
        @visa_information = VisaInformation.create!(
          country: @location.country,
          # Assume only one citizenship for now
          citizenship: citizenship_country,
          body: ChatGpt.generate_visa_info(
            country: @location.country,
            citizenship_country: citizenship_country
          )
        )
      end
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "location-visa-information",
          partial: "visa_informations/location_visa_information",
          locals: {
            user: current_user,
            visa_information: @visa_information
          }
        )
      end
    end
  end
end

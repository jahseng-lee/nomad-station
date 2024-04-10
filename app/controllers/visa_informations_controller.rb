class VisaInformationsController < ApplicationController
  before_action :initialize_markdown_renderer
  skip_before_action :authenticate_user!, only: [:show, :content]

  def show
    @location = Location.find(params[:location_id])
  end

  def edit
    @location = Location.find(params[:location_id])
    @visa_information = params[:id].present? ? (
      VisaInformation.find_by(id: params[:id])
    ) : (
      VisaInformation.generic(country: @location.country)
    )
    @visa_informations = VisaInformation
      .includes(:citizenship)
      .where(
        country: @location.country
      )
      .order("countries.name")
  end

  def update
    @location = Location.find(params[:location_id])
    @visa_information = VisaInformation.find(params[:id])

    @visa_information.assign_attributes(
      body: update_params[:body]
    )

    if @visa_information.save
      flash.now[:success_update_visa] = "Updated visa info."
    else
      flash.now[:error_update_visa] = "Couldn't update visa info." \
        " Please try again."
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "update-visa-info-form",
          partial: "visa_informations/update_visa_info_form",
          locals: {
            location: @location,
            visa_information: @visa_information
          }
        )
      end
    end
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

  def report_issue_modal
    @location = Location.find(params[:location_id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "site-modals",
          partial: "visa_informations/report_issue_modal"
        )
      end
    end
  end

  private

  def update_params
    params.require(:visa_information).permit(:body)
  end
end

# Controller responsible for adding citizenships from the
# VisaInformation#show page. This differs from the CitizenshipsController
# which is used on the Profile#show page
module Locations
  class CitizenshipsController < ApplicationController
    before_action :initialize_markdown_renderer, only: [:create]

    def create
      @user = User.find(params[:user_id])
      # Used for fetching the right VisaInformation, see
      # app/views/citizenships/create.turbo_stream.erb for usage
      @location = Location.find(params[:location_id])

      authorize(@user, :update?)

      @citizenship = Citizenship.new(
        user: @user,
        country_id: citizenship_params[:country_id]
      )

      if @citizenship.save
        @visa_information = VisaInformation.find_by(
          country: @location.country,
          citizenship: @citizenship.country
        )

        flash.now[:success_save_citizenship] = "Added citizenship!" \
          " From now on, you'll see visa information specific to your" \
          " citizenship."
      else
        flash.now[:error_save_citizenship] = "Oops! Something went" \
          " wrong. Please refresh and try again."
      end

      respond_to do |format|
        format.turbo_stream
      end
    end

    def modal_new
      @user = User.find(params[:user_id])
      @location = Location.find(params[:location_id])

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "site-modals",
            partial: "locations/citizenships/modal_new"
          )
        end
      end
    end

    private

    def citizenship_params
      params.require(:citizenship).permit(:country_id, :location_id)
    end
  end
end

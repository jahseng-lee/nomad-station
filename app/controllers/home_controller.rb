class HomeController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!

  def index; end

  def locations
    @pagy, @locations = pagy(
      Location.all
        .includes(:tags)
        .ordered_for_search_results,
      items: 18
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "loading-locations",
          partial: "search_locations/location_search_section",
          locals: {
            region: nil,
            country: nil,
            locations: @locations
          }
        )
      end
    end
  end
end

class HomeController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!

  def index
    # NOTE: we're still reviews.pluck("avg(overall)") for reviews
    #       for each location, but fine for now.
    #       Consider:
    #       * lazily loading review averages; AND/OR
    #       * a materialized view
    #       if it gets very slow
    @pagy, @locations = pagy(
      Location.all
        .includes(:tags)
        .includes(:banner_image)
        .includes(:country)
        .includes(:reviews)
        .ordered_for_search_results,
      items: 18
    )
  end
end

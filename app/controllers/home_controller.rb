class HomeController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!

  def index
    @pagy, @locations = pagy(
      Location.all
        .includes(:tags)
        .ordered_for_search_results,
      items: 18
    )
  end
end

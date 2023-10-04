class SearchLocationsController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!

  def index
    @region = Region.find_by(id: search_params[:region_id])
    @country = Country.find_by(id: search_params[:country_id])
    @query = search_params[:query]

    @locations = Location.all

    if @region.present?
      @locations = @locations.by_region(search_params[:region_id])
    end
    if @country.present?
      @locations = @locations.by_country(search_params[:country_id])
    end

    if @query.present?
      @pagy, @locations = pagy(
        @locations.search_by_name(@query),
        items: 18
      )
    else
      @pagy, @locations = pagy(
        @locations.ordered_for_search_results,
        items: 18
      )
    end

    respond_to do |format|
      format.html do
        render template: "home/index"
      end
    end
  end

  private

  def search_params
    params.require(:search).permit(
      :region_id,
      :country_id,
      :query,
    )
  end
end

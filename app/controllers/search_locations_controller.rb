class SearchLocationsController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!

  def index
    @region = Region.find_by(id: search_params[:region_id])
    @country = Country.find_by(id: search_params[:country_id])
    @query = search_params[:query]

    # Apply search query first
    if @query.present?
      location_ids = PgSearch
        .multisearch(I18n.transliterate(@query))
        .where(searchable_type: "Location")
        .pluck(:searchable_id)
      @locations = Location.where(id: location_ids)
    else
      @locations = Location.all
    end

    # Apply region, country and tag filters
    if @region.present?
      @locations = @locations.by_region(search_params[:region_id])
    end
    if @country.present?
      @locations = @locations.by_country(search_params[:country_id])
    end
    if params[:filter].present?
      filter_array = params[:filter].split(",");
      @locations = @locations
        .joins(:tags)
        .where(tags: { name: filter_array })
    end

    # Paginate and order
    @pagy, @locations = pagy(
      @locations.ordered_for_search_results,
      items: 18
    )

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
      :filter
    )
  end
end

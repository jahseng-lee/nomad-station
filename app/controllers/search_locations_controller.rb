class SearchLocationsController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!

  def index
    @region = Region.find_by(id: search_params[:region_id])
    @country = Country.find_by(id: search_params[:country_id])
    @query = search_params[:query]

    # Apply search query first
    if @query&.present?
      location_documents = PgSearch
        .multisearch(I18n.transliterate(@query))
        .where(searchable_type: "Location")
    else
      location_documents = PgSearch::Document
        .where(searchable_type: "Location")
    end

    # Apply region and country filters
    if @region.present?
      location_documents = location_documents.where(
        region_id: search_params[:region_id]
      )
    end
    if @country.present?
      location_documents = location_documents.where(
        country_id: search_params[:country_id]
      )
    end

    # Get the locations
    @locations = Location.where(id: location_documents.pluck(:searchable_id))

    # Apply tag filters
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

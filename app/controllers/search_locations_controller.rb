class SearchLocationsController < ApplicationController
  def index
    @region = Region.find_by(id: search_params[:region_id])
    @country = Country.find_by(id: search_params[:country_id])

    @locations = Location.all

    if @region.present?
      @locations = @locations.by_region(search_params[:region_id])
    end
    if @country.present?
      @locations = @locations.by_country(search_params[:country_id])
    end

    # TODO use stimulus to update search results and
    #      dropdown form
    # TODO ensure URL is set correctly after search
    render template: "home/index"
  end

  private

  def search_params
    params.require(:search).permit(
      :region_id,
      :country_id
    )
  end
end

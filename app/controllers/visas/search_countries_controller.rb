class Visas::SearchCountriesController < ApplicationController
  def index
    if current_user.admin?
      @visa = Visa.find(params[:visa_id])
      @query = params[:query]

      @countries = Country
        .search_by_name(I18n.transliterate(@query))
        .limit(10)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "search-results",
            partial: "visas/search_results",
            locals: {
              countries: @countries,
              visa: @visa,
              location_id: params[:location_id],
              country_id: params[:country_id],
            }
          )
        end
      end
    end
  end
end

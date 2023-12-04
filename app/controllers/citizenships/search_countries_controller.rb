class Citizenships::SearchCountriesController < ApplicationController
  def index
    @query = params[:query]

    @countries = Country
      .search_by_name(I18n.transliterate(@query))
      .limit(10)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "search-results",
          partial: "citizenships/search_results",
          locals: {
            countries: @countries,
          }
        )
      end
    end
  end
end

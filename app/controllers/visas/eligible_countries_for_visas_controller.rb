class Visas::EligibleCountriesForVisasController < ApplicationController
  def create
    @visa = Visa.find(params[:visa_id])
    @country = Country.find(params[:country_id])
    @eligible_country = Country.find(
      eligible_countries_for_visa_params[:eligible_country_id]
    )

    authorize(@country, :edit?)

    @eligible_countries_for_visa = EligibleCountriesForVisa.new(
      visa: @visa,
      eligible_country: @eligible_country
    )

    respond_to do |format|
      format.turbo_stream do
        unless @eligible_countries_for_visa.save
          flash.now[:error_create_eligible_country] = "Couldn't link that country to the visa right now. Please try again"
        end

        render "eligible_countries_for_visas/create"
      end
    end
  end

  def destroy
    @visa = Visa.find(params[:visa_id])
    @country = Country.find(params[:country_id])
    @eligible_countries_for_visa = EligibleCountriesForVisa.find(
      params[:id]
    )

    authorize(@country, :edit?)

    @eligible_countries_for_visa.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "eligible-countries",
          partial: "visas/eligible_countries",
          locals: {
            visa: @visa,
            location_id: params[:location_id],
            country_id: @country.id,
          }
        )
      end
    end
  end

  private

  def eligible_countries_for_visa_params
    params
      .require(:eligible_countries_for_visa)
      .permit(:eligible_country_id)
  end
end

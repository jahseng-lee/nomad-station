class CountriesController < ApplicationController
  def edit
    @country = Country.find(params[:id])
    @location = @country.locations.find(params[:location_id])

    authorize(@country)
  end

  def update
    @country = Country.find(params[:id])
    @location = @country.locations.find(params[:location_id])

    authorize(@country)

    # NOTE this is supremely lazy
    #      however, admin only. Fine for now
    @country.update!(country_params)
    redirect_to @location
  end

  private

  def country_params
    params.require(:country).permit(
      :ambulance_number,
      :police_number,
      :fire_number
    )
  end
end

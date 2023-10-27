class CountriesController < ApplicationController
  def update
    @country = Country.find(params[:id])

    authorize(@country)

    @country.assign_attributes(
      visa_summary_information: country_params[:visa_summary_information]
    )

    if @country.save
      flash[:success_update_visa_information] = "Updated visa information"

      redirect_to location_visa_information_path(
        location_id: country_params[:location_id]
      )
    else
      flash[:error_update_visa_information] = "Couldn't update visa information. Please try again"

      render "visas/edit"
    end
  end

  private

  def country_params
    params.require(:country).permit(
      :visa_summary_information,
      :location_id # for redirect
    )
  end
end

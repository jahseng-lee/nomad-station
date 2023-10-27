class VisasController < ApplicationController
  before_action :initialize_markdown_renderer, only: [:show]

  def new
    @country = Country.find(params[:country_id])
    @location = Location.find(params[:location_id])

    authorize(@country, :edit?)

    @visa = Visa.new
  end

  def create
    @country = Country.find(params[:country_id])
    @location = Location.find(params[:location_id])

    authorize(@country, :edit?)

    @visa = Visa.new(
      country: @country,
      name: visa_params[:name]
    )

    if @visa.save
      flash[:success_save_visa] = "Visa saved"

      redirect_to edit_country_location_visa_path(
        @visa,
        country_id: @country.id,
        location_id: @location.id
      )
    else
      flash[:error_save_visa] = "Couldn't save visa. Please try again"

      render :new
    end
  end

  def edit
    @country = Country.find(params[:country_id])
    @location = Location.find(params[:location_id])
    @visa = Visa.find(params[:id])

    authorize(@country, :edit?)
  end

  def update
    @country = Country.find(params[:country_id])
    @location = Location.find(params[:location_id])
    @visa = Visa.find(params[:id])

    authorize(@country, :edit?)

    @visa.assign_attributes(name: visa_params[:name])

    if @visa.save
      flash[:success_save_visa] = "Visa saved"

      redirect_to edit_country_location_visa_path(
        @visa,
        country_id: @country.id,
        location_id: @location.id
      )
    else
      flash[:error_save_visa] = "Couldn't save visa. Please try again"

      render :edit
    end
  end

  private

  def visa_params
    params.require(:visa).permit(:name)
  end
end

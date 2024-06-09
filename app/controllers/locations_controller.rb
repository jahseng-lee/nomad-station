class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :initialize_markdown_renderer, only: [:show]

  def show
    @location = Location.find(params[:id])
  end

  def edit
    @location = Location.find(params[:id])
    authorize(@location)
  end

  def update
    @location = Location.find(params[:id])
    authorize(@location)

    @location.assign_attributes(location_params)

    if @location.save
      flash[:success_update_location] = "Updated location"

      redirect_to @location
    else
      flash[:error_update_location] = "Couldn't update location. Please try again"
      render :edit
    end
  end

  def destroy
    @location = Location.find(params[:id])
    authorize(@location)

    if @location.delete
      flash[:success_delete_location] = "Location '#{@location.name}' deleted"

      redirect_to root_path
    else
      flash[:error_delete_location] = "Couldn't delete '#{@location.name}', please try again"

      redirect_to @location
    end
  end

  def generate_description
    @location = Location.find(params[:id])
    authorize(@location, :edit?)

    @location.assign_attributes(
      description: GenerateLocationDescription.call(location: @location)
    )

    if @location.save
      flash[:success_generate_description] = "Auto-generation successful"

      redirect_to edit_location_path(@location)
    else
      flash[:error_generate_description] = "Couldn't save auto-generated description. Please try again"

      render :edit
    end
  end

  def upload_banner_image_modal
    @location = Location.find(params[:id])
    authorize(@location, :edit?)

    if @location.banner_image.present?
      @banner_image = @location.banner_image
    else
      @banner_image = BannerImage.new
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "site-modals",
          partial: "locations/upload_banner_image_modal",
          locals: {
            location: @location,
            banner_image: @banner_image
          }
        )
      end
    end
  end

  def emergency_info
    # Intended to be a mobile/small screen only link as normally the
    # emergency info is hidden on mobile
    @location = Location.find(params[:id])
  end

  private

  def location_params
    params.require(:location).permit(:description, :official_visa_link)
  end
end

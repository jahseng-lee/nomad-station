class BannerImagesController < ApplicationController
  def create
    @location = Location.find(params[:location_id])
    authorize(@location, :edit?)

    @banner_image = BannerImage.new(
      location: @location,
      image: banner_image_params[:image],
      image_credit: banner_image_params[:image_credit]
    )

    if @banner_image.save
      redirect_to @location
    else
      flash[:error_upload_banner_image] = "Couldn't upload banner image. Please try again"

      redirect_to @location
    end
  end

  def update
    @location = Location.find(params[:location_id])
    authorize(@location, :edit?)

    @banner_image = @location.banner_image.assign_attributes(
      location: @location,
      image: banner_image_params[:image],
      image_credit: banner_image_params[:image_credit]
    )

    if @banner_image.save
      redirect_to @location
    else
      flash[:error_upload_banner_image] = "Couldn't upload banner image. Please try again"

      redirect_to @location
    end
  end

  private

  def banner_image_params
    params.require(:banner_image).permit(
      :image,
      :image_credit
    )
  end
end

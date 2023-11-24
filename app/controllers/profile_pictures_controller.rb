class ProfilePicturesController < ApplicationController
  def create
    @user = User.find(params[:user_id])

    authorize(@user, :edit?)

    @profile_picture = ProfilePicture.new(
      user: @user,
      image: profile_picture_params[:image]
    )

    if @profile_picture.save
      redirect_to profile_path
    else
      flash[:error_upload_profile_picture] = "Couldn't upload profile picture. Please try again"

      redirect_to profile_path
    end
  end

  def update
    @user = User.find(params[:user_id])

    authorize(@user, :edit?)

    @user.profile_picture.assign_attributes(
      image: profile_picture_params[:image]
    )

    if @user.profile_picture.save
      redirect_to profile_path
    else
      flash[:error_upload_profile_picture] = "Couldn't upload profile picture. Please try again"

      redirect_to profile_path
    end
  end

  def upload_modal
    @user = User.find(params[:user_id])

    authorize(@user, :edit?)

    if @user.profile_picture.present?
      @profile_picture = @user.profile_picture
    else
      @profile_picture = ProfilePicture.new
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "site-modals",
          partial: "profile_pictures/upload_modal",
          locals: {
            user: @user,
            profile_picture: @profile_picture
          }
        )
      end
    end
  end

  private

  def profile_picture_params
    params.require(:profile_picture).permit(
      :image
    )
  end
end

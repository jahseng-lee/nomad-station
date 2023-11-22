class ProfilePicturesController < ApplicationController
  def create
    raise NotImplementedError, "TODO"
  end

  def update
    raise NotImplementedError, "TODO"
  end

  def upload_modal
    # TODO return a turbo_stream modal with
    #      a form to upload profile picture
    raise NotImplementedError, "TODO"
  end

  private

  def profile_picture_params
    params.require(:profile_picture).permit(
      :image
    )
  end
end

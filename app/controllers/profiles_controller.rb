class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def overview
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "profile_reviews",
          partial: "profiles/profile_overview",
          locals: {
            user: current_user
          }
        )
      end
    end
  end

  def reviews
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "profile_overview",
          partial: "profiles/profile_reviews",
          locals: {
            user: current_user
          }
        )
      end
    end
  end
end

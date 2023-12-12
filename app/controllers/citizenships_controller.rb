class CitizenshipsController < ApplicationController
  before_action :authenticate_subscription!

  def new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "profile-citizenship-section",
          partial: "citizenships/add_citizenship_form"
        )
      end
    end
  end

  def create
    @citizenship = Citizenship.new(
      citizenship_params.merge(
        user: current_user
      )
    )

    authorize(@citizenship)

    unless @citizenship.save
      flash.now[:error_create_citizenship] = "Oops! Something went wrong. Please try again"
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "profile-citizenship-section",
          partial: "profiles/citizenships"
        )
      end
    end
  end

  def destroy
    raise NotImplementedError, "TODO"
  end

  private

  def citizenship_params
    params.require(:citizenship).permit(
      :country_id
    )
  end
end

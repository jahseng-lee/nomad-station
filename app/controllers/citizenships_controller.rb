class CitizenshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])

    authorize(@user, :update?)

    @citizenship = Citizenship.new(
      user: @user,
      country_id: citizenship_params[:country_id]
    )

    if @citizenship.save
      flash.now[:success_save_citizenship] = "Added citizenship!" \
        " From now on, you'll see visa information specific to your" \
        " citizenship."
    else
      flash.now[:error_save_citizenship] = "Oops! Something went" \
        " wrong. Please refresh and try again."
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    @user = User.find(params[:user_id])

    authorize(@user, :update?)

    @citizenship = @user.citizenship
    @citizenship.assign_attributes(
      country_id: citizenship_params[:country_id]
    )

    if @citizenship.save
      flash.now[:success_save_citizenship] = "Updated citizenship" \
    else
      flash.now[:error_save_citizenship] = "Oops! Something went" \
        " wrong. Please refresh and try again."
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def modal
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "site-modals",
          partial: "citizenships/modal"
        )
      end
    end
  end

  private

  def citizenship_params
    params.require(:citizenship).permit(:country_id)
  end
end

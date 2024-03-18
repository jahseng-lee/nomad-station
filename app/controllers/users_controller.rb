class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])

    if current_user && current_user == @user
      redirect_to profile_path
    end
  end

  def update
    @user = User.find(params[:id])

    authorize(@user)

    @user.assign_attributes(display_name: user_params[:display_name])

    if @user.save
      flash[:updated_user_success] = "Updated your details"

      redirect_to profile_path
    else
      render template: "profiles/show"
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :display_name
    )
  end
end

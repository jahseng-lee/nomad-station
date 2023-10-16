class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :display_name,
      ]
    )
  end

  def authenticate_subscription!
    unless current_user.active_subscription?
      redirect_to choose_plan_path
    end
  end
end

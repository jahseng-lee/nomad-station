class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(*)
    new_user_session_path
  end

  def after_sign_in_path_for(user)
    if user.admin? || user.active_subscription?
      redirect_to root_path
    else
      redirect_to choose_plan_path
    end
  end
end


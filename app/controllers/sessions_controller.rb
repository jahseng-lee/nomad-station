class SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(user)
    if user.admin? || user.active_subscription?
      root_path
    else
      choose_plan_path
    end
  end
end


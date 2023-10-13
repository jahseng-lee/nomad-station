class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(resource_name, user)
    sign_in(user)

    if user.admin?
      root_path
    else
      choose_plan_path
    end
  end
end


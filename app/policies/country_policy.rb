class CountryPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end

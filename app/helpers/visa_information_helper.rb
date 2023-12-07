module VisaInformationHelper
  def helper_eligible_visas(country:, user:)
    if user.admin? || user.citizenships.none?
      country.visas
    else
      # Non-admin user who has added citizenships
      country
        .visas
        .left_joins(:eligible_countries_for_visas)
        .where(
          eligible_countries_for_visas: {
            country_id: user.citizenships.pluck(:country_id)
          }
        )
    end
  end
end

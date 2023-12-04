module ProfilesHelper
  def helper_eligible_visas(country:, user:)
    if user.citizenships.any?
      country
        .visas
        .left_joins(:eligible_countries_for_visas)
        .where(
          eligible_countries_for_visas: {
            country_id: user.citizenships.pluck(:country_id)
          }
        )
    else
      country.visas
    end
  end
end

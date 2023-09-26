module LocationsHelper
  def helper_location_description(location:)
    if location.description.present?
      location.description
    else
      "Make sure you put #{location.name_utf8} on your travel list!"
    end
  end
end

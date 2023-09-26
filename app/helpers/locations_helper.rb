module LocationsHelper
  def helper_location_short_description(location:)
    description = helper_location_description(location: location)

    description.length <= 150 ? description : description[0..147] + "..."
  end

  def helper_location_description(location:)
    if location.description.present?
      simple_format(location.description)
    else
      "Make sure you put #{location.name_utf8} on your travel list!"
    end
  end
end

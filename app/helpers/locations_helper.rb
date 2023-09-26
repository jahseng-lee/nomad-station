module LocationsHelper
  def helper_location_description(location:)
    location.description ||
      "Make sure you put #{location.name_utf8} on your travel list!"
  end
end

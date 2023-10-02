class GenerateLocationDescription
  def self.call(location:)
    if Rails.env.production?
      ChatGpt.generate_location_description(location: location)
    else
      "This content was auto-generated. In production, this should call ChatGPT instead"
    end
  end
end

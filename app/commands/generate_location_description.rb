class GenerateLocationDescription
  def self.call(location:)
    if Rails.env.production?
      # TODO implemented ChatGPT generation
    else
      "This content was auto-generated. In production, this should call ChatGPT instead"
    end
  end
end

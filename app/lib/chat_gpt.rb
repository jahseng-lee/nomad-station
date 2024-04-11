class ChatGpt
  def self.generate_location_description(location:)
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: "Could you generate a short paragraph of"\
              " why people should visit"\
              " #{location.name_utf8}, #{location.country_name}? Make it"\
              " 500-900 characters long and aimed at Digital Nomads."\
              " Please include line breaks and paragraph breaks every 1"\
              " to 3 sentences, this is very important."
          }
        ],
        temperature: 1.0,
      }
    )
    response.dig("choices")[0].dig("message", "content")
  end

  def self.generate_location_tags(location:)
    prompt = "Could you give me the most relevant tags for"\
      " #{location.name_utf8}, #{location.country_name} from this"\
      " array? Don't tag 'Popular' unless it's a highly visited"\
      " destination for digital nomads in particular. Don't tag"\
      " 'Shopping' unless it's a world renowed shopping center.\n"\
      " #{Tag.pluck(:name)}\n"\
      " Make your answer an array of tags and nothing else, as if you"\
      " were a JSON API. Limit the maximum tags to 6."
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 1.0,
      }
    )
    response.dig("choices")[0].dig("message", "content")
  end

  def self.generate_generic_visa_info(country:)
    prompt = "Could you write me an informational article that explains" \
      " the visa options for digital nomads visiting #{country.name}?" \
      " List the available visa options in a numbered list." \
      " Don't include a title, introductory paragraph or any colourful" \
      " language. <strong> tag the visa name for each visa with mark" \
      " up, i.e. <strong>1. Work Visa:</strong>"

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 1.0,
      }
    )
    response.dig("choices")[0].dig("message", "content")
  end

  def self.generate_visa_info(country:, citizenship_country:)
    unless Rails.env.production?
      return "Visa info. for citizenship: #{citizenship_country.name}," \
        " country: #{country.name}."
    end

    prompt = "Could you write me an informational article that explains" \
      " the visa options for a digital nomad who is a" \
      " #{citizenship_country.name} citizen visiting #{country.name}?" \
      " List the available visa options in a numbered list." \
      " Don't include a title, introductory paragraph or any colourful" \
      " language. <strong> tag the visa name for each visa with mark" \
      " up, i.e. <strong>1. Work Visa:</strong>"

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 1.0,
      }
    )
    response.dig("choices")[0].dig("message", "content")
  end

  private

  def self.client
    @client ||= OpenAI::Client.new
  end
end

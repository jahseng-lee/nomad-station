class ChatGpt
  def self.generate_location_description(location:)
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: "Could you generate a short paragraph of"\
              " why people should visit"\
              " #{location.name_utf8}, #{location.country.name}? Make it"\
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
end

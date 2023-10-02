class ChatGpt
  def self.generate_location_description(location:)
    client = OpenAI::Client.new
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: "Could you generate a short paragraph of"\
              " why people should visit"\
              " #{location.name_utf8}, #{location.country.name}? Make it"\
              " 500-700 characters long and aimed at Digital Nomads."\
          }
        ],
        temperature: 0.7,
      }
    )
  end

  def self.generate_location_review(location:)
    raise NotImplementedError, "TODO"
  end
end

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
              " 500-700 characters long and aimed at Digital Nomads."\
          }
        ],
        temperature: 0.7,
      }
    )
    response.dig("choices")[0].dig("message", "content")
  end

  def self.generate_location_review(location:)
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: "I want a review of"\
            " #{location.name_utf8}, #{location.country.name}. I want you"\
            " to rate it on a scale of 1-5, for the following things:"\
            " overall, fun, internet, cost, safety. I want the response"\
            " in a JSON format, i.e. { overall: 5, fun: 5, cost: 5,"\
            " internet: 5, safety: 5 }"
          }
        ],
        temperature: 0.5,
      }
    )
   JSON.parse(response.dig("choices")[0].dig("message", "content"))
  end
end

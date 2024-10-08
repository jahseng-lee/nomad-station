namespace :gpt_generate do
  desc "Generate location descriptions for all locations"
  task location_descriptions: :environment do
    Location.where(description: nil).find_each(batch_size: 10) do |location|
      if Rails.env.production?
        desc = ChatGpt.generate_location_description(location: location)
        location.update!(description: desc)

        puts "Updated #{location.name_utf8} with description"
      else
        puts "Calling gpt_generate:location_descriptions for #{location.name_utf8} in a non-production environment"
      end
    end
  end
end

namespace :locations do
  desc "Prunes all locations with no banner images"
  task prune: :environment do
    Location.find_each do |location|
      if location.banner_image.nil?
        location.delete

        puts "Deleted #{location.name}"
      end
    end
  end

  desc "Tags all locations using ChatGpt"
  task tag_all: :environment do
    Location.find_each do |location|
      if location.tags.any?
        puts "#{location.name_utf8}, #{location.country.name} already has tags - skipping."
        next
      end
      puts "Tagging #{location.name_utf8}, #{location.country.name}"

      tags_array = JSON.parse(
        ChatGpt.generate_location_tags(location: location)
      )

      tags_array.each do |tag_name|
        tag = Tag.find_by(name: tag_name)

        if tag.nil?
          puts "Couldn't find tag with #{tag_name}, skipping"
          next
        end

        location.tags << tag
      end
      puts "Finished tagging"\
        " #{location.name_utf8}, #{location.country.name}"
    end
  end
end

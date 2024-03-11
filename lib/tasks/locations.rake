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

  desc "Applies a specific tag to a location"
  task :tag_location, [:location_id, :tag_name] => :environment do |t, args|
    if args[:location_id] == nil
      abort("Must supply a location_id and a tag_name, i.e. tag_location[1, \"Beach\"]")
    end
    if args[:tag_name] == nil
      abort("Must supply a location_id and a tag_name, i.e. tag_location[1, \"Beach\"]")
    end

    location = Location.find_by(id: args[:location_id])
    if location.nil?
      abort("Location with id: #{args[:location_id]} not found")
    end

    tag = Tag.find_by(name: args[:tag_name])
    if tag.nil?
      abort("Tag with name #{args[:tag_name]} not found")
    end

    location.tags << tag
  end

  desc "Removes a specific tag from a location"
  task :untag_location, [:location_id, :tag_name] => :environment do |t, args|
    if args[:location_id] == nil
      abort("Must supply a location_id and a tag_name, i.e. tag_location[1, \"Beach\"]")
    end
    if args[:tag_name] == nil
      abort("Must supply a location_id and a tag_name, i.e. tag_location[1, \"Beach\"]")
    end

    location = Location.find_by(id: args[:location_id])
    if location.nil?
      abort("Location with id: #{args[:location_id]} not found")
    end

    tag = location.tags.find_by(name: args[:tag_name])
    if tag.nil?
      abort("Tag with name #{args[:tag_name]} not found on location #{location.name_utf8}")
    end

    location.tags.delete(tag)
  end
end

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
end

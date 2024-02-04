namespace :locations do
  # Task below is intended to be run one gpt_generate:location_descriptions
  # has been run for a fair number of locations. Having really remote
  # locations listed on the 2000th page doesn't seem like it's providing
  # much value
  desc "Prunes all locations with no description"
  task prune: :environment do
    Location.where(description: nil).find_each do |location|
      location.delete

      puts "Deleted #{location.name}"
    end
  end
end

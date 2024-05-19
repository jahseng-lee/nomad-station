# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.nomadstation.pio"

SitemapGenerator::Sitemap.create do
  add "/chat"
  Channel.find_each do |channel|
    add channel_path(channel)
  end

  Location.find_each do |location|
    add location_path(location)
    add location_visa_information_path(location)
    add location_reviews_path(location)

    location.reviews.find_each do |review|
      add location_review_path(review, location_id: location.id)
    end
  end

  User.find_each do |user|
    add user_path(user)
  end
end

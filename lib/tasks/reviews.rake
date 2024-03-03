namespace :reviews do
  desc "Removes all content-robot reviews and the account itself"
  task prune_robot_reviews: :environment do
    content_bot = User.find_by(email: "content-robot@nomadstation.io")

    Review.where(user: content_bot).find_each do |review|
      review.delete

      puts "Deleted review: #{review.id}"
    end

    content_bot.delete

    puts "Deleted content-robot account"
  end
end


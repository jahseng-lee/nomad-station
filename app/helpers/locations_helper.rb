module LocationsHelper
  def helper_location_short_description(location:)
    description = helper_location_description(location: location)

    description.length <= 150 ? description : description[0..147] + "..."
  end

  def helper_location_description(location:)
    if location.description.present?
      simple_format(location.description)
    else
      "Make sure you put #{location.name_utf8} on your travel list!"
    end
  end

  def helper_review_summary_star_rating(location:, review_field:)
    rating = location.review_summary[review_field]

    split_rating = rating.to_s.split(".") # e.g. 4.7
    integral = Integer(split_rating[0]) # e.g. 4
    fractional = Integer(split_rating[1]) # e.g. 7

    number_of_whole_stars = integral
    number_of_empty_stars = 5 - integral
    number_of_half_stars = 0
    if fractional >= 8
      number_of_whole_stars += 1
      number_of_empty_stars -= 1
    elsif fractional < 8 && fractional >= 3
      number_of_half_stars = 1
      number_of_empty_stars -= 1
    end

    return (
      rating.to_s + " " +
      (ReviewHelper::STAR_FILLED * number_of_whole_stars) +
      (ReviewHelper::STAR_HALF_FILLED * number_of_half_stars) +
      (ReviewHelper::STAR_EMPTY * number_of_empty_stars)
    ).html_safe
  end
end

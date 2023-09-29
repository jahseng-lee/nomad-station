module ReviewHelper
  STAR_FILLED = '<i class="bi bi-star-fill" aria-hidden="true"></i>'
  STAR_EMPTY = '<i class="bi bi-star" aria-hidden="true"></i>'

  def helper_review_rating_options
    (1..5).map{ |i| [i, i] }
  end

  def helper_star_rating(rating:)
    stars = ""

    (5 - rating).times { |i| stars = stars + STAR_EMPTY }
    rating.times { |i| stars = stars + STAR_FILLED }

    stars.html_safe
  end
end

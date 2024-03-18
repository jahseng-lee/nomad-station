module UsersHelper
  def helper_short_body(review:)
    review.body.length <= 250 ? review.body : review.body[0..247] + "..."
  end
end

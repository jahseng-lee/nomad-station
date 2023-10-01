class GenerateLocationReview
  class NoCotentRobotAccountError < StandardError; end
  class AlreadyGeneratedError < StandardError; end

  def self.call(location:)
    @content_account = User.find_by(
      email: "content-robot@nomadstation.io"
    )

    if @content_account.nil?
      raise NoCotentRobotAccountError,
        "Please create 'content-robot@nomadstation.io' account by running `rails db:seed`"
    end

    if Review.find_by(location: location, user: @content_account).present?
      raise AlreadyGeneratedError,
        "Auto-generated review already exists for this location"
    end

    if Rails.env.production?
      # TODO implemented ChatGPT generation of a review
    else
      # For local and test, just create a dummy review
      Review.new(
        user: @content_account,
        location: location,
        overall: 5,
        fun: 5,
        internet: 5,
        cost: 5,
        safety: 5,
      )
    end
  end
end

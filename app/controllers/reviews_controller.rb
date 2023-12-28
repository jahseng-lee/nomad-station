class ReviewsController < ApplicationController
  before_action :authenticate_subscription!

  def index
    @location = Location.find(params[:location_id])
    @reviews = @location.reviews.order(created_at: :desc)
  end

  def show
    @location = Location.find(params[:location_id])
    @review = Review.find(params[:id])

    authorize(@review)
  end

  def new
    @location = Location.find(params[:location_id])
    @review = Review.new

    authorize(@review)
  end

  def create
    @location = Location.find(params[:location_id])
    @review = Review.new(user: current_user, location: @location)
    authorize(@review)

    @review.assign_attributes(review_params)

    if @review.save
      flash[:success_save_review] = "Saved review"

      redirect_to location_review_path(
        @review,
        location_id: @location.id
      )
    else
      respond_to do |format|
        format.html do
          flash[:error_save_review] = "Couldn't save your review"

          render :new
        end

        format.turbo_stream do
          flash.now[:error_save_review] = "Couldn't save your review"

          render turbo_stream: turbo_stream.replace(
            "review-form",
            partial: "reviews/shared/form",
            locals: {
              location: @location,
              review: @review
            }
          )
        end
      end
    end
  end

  def edit
    @location = Location.find(params[:location_id])
    @review = Review.find(params[:id])

    authorize(@review)
  end

  def update
    @location = Location.find(params[:location_id])
    @review = Review.find(params[:id])

    authorize(@review)

    @review.assign_attributes(review_params)

    if @review.save
      flash[:success_save_review] = "Saved review"

      redirect_to location_review_path(
        @review,
        location_id: @location.id
      )
    else
      respond_to do |format|
        format.html do
          flash[:error_save_review] = "Couldn't save your review"

          render :edit
        end

        format.turbo_stream do
          flash.now[:error_save_review] = "Couldn't save your review"

          render turbo_stream: turbo_stream.replace(
            "review-form",
            partial: "reviews/shared/form",
            locals: {
              location: @location,
              review: @review
            }
          )
        end
      end
    end
  end

  def generate_review
    @location = Location.find(params[:location_id])
    @review = GenerateLocationReview.call(location: @location)

    authorize(@review)

    if @review.save
      flash[:success_generate_review] = "Review auto-generated successfully"

      redirect_to location_review_path(
        @review,
        location_id: @location.id
      )
    else
      flash[:error_generate_review] = "Couldn't auto-generate review; please try again"

      render :new
    end
  rescue GenerateLocationReview::NoCotentRobotAccountError,
    GenerateLocationReview::AlreadyGeneratedError => e
    flash[:error_generate_review] = e.message

    # Ensure an empty review for the Review form
    @review = Review.new

    render :new
  end

  private

  def review_params
    params.require(:review).permit(
      :overall,
      :fun,
      :cost,
      :internet,
      :safety,
      :body
    )
  end
end

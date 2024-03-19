class ReviewsController < ApplicationController
  before_action :authenticate_subscription!,
    only: [:new, :create, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

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

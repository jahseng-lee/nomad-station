class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

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
      flash[:error_save_review] = "Couldn't save your review"

      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
    authorize(@review)
  end

  def update
    raise NotImplementedError, "TODO"
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

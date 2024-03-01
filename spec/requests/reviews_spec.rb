require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  let(:location) { create(:location) }
  let(:params) do
    {
      review: {
        overall: overall,
        fun: fun,
        cost: cost,
        internet: internet,
        safety: safety,
        body: review_body
      }
    }
  end

  describe "POST #create" do
    let(:review_body) { nil }

    context "with valid params" do
      let(:overall) { 5 }
      let(:fun) { 4 }
      let(:cost) { 3 }
      let(:internet) { 2 }
      let(:safety) { 1 }
      let(:review_body) { "#{location.name} was great!" }

      it "creates a review and redirects to it" do
        expect{
          post location_reviews_path(location), params: params
        }.to change{ Review.count }

        review = Review.last

        expect(review.overall).to eq overall
        expect(review.fun).to eq fun
        expect(review.cost).to eq cost
        expect(review.internet).to eq internet
        expect(review.safety).to eq safety
        expect(review.body).to eq review_body

        expect(response.status).to eq 302
      end
    end

    context "with invalid params" do
      let(:overall) { nil }
      let(:fun) { nil }
      let(:cost) { nil }
      let(:internet) { nil }
      let(:safety) { nil }

      it "does not creat a review" do
        expect{
          post location_reviews_path(location), params: params
        }.not_to change{ Review.count }
      end
    end
  end

  describe "PUT #update" do
    let(:old_overall) { 5 }
    let(:old_fun) { 5 }
    let(:old_cost) { 5 }
    let(:old_internet) { 5 }
    let(:old_safety) { 5 }
    let(:old_review_body) { "#{location.name} was okay!" }
    let(:review) do
      Review.create!(
        user: user,
        location: location,
        overall: old_overall,
        fun: old_fun,
        cost: old_cost,
        internet: old_internet,
        safety: old_safety,
        body: old_review_body,
      )
    end

    context "with valid params" do
      let(:overall) { 4 }
      let(:fun) { 4 }
      let(:cost) { 4 }
      let(:internet) { 4 }
      let(:safety) { 4 }
      let(:review_body) { "#{location.name} was great!" }

      it "updates the review and redirects to it" do
        put location_review_path(
          review, location_id: location
        ), params: params

        review = Review.last

        expect(review.overall).to eq overall
        expect(review.fun).to eq fun
        expect(review.cost).to eq cost
        expect(review.internet).to eq internet
        expect(review.safety).to eq safety
        expect(review.body).to eq review_body

        expect(response.status).to eq 302
      end
    end

    context "with invalid params" do
      let(:overall) { 4 }
      let(:fun) { 4 }
      let(:cost) { 4 }
      let(:internet) { 4 }
      let(:safety) { nil }
      let(:review_body) { "#{location.name} was awful!" }

      it "does not update the review" do
        put location_review_path(
          review, location_id: location
        ), params: params

        expect(review.overall).to eq old_overall
        expect(review.fun).to eq old_fun
        expect(review.cost).to eq old_cost
        expect(review.internet).to eq old_internet
        expect(review.safety).to eq old_safety
        expect(review.body).to eq old_review_body
      end
    end
  end
end

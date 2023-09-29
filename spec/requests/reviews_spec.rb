require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) do
    u = User.create!(
      email: "jahseng@nomadstation.com",
      password: "Pa55w0rd",
    )

    u.confirm
    u
  end
  before do
    sign_in user
  end

  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end

  describe "#create" do
    let(:review_body) { nil }
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

    context "with valid params" do
      let(:overall) { 5 }
      let(:fun) { 4 }
      let(:cost) { 3 }
      let(:internet) { 2 }
      let(:safety) { 1 }
      let(:review_body) { "Wellington was great!" }

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
end

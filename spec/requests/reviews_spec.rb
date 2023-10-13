require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user) }
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

  describe "PUT #update" do
    let(:old_overall) { 5 }
    let(:old_fun) { 5 }
    let(:old_cost) { 5 }
    let(:old_internet) { 5 }
    let(:old_safety) { 5 }
    let(:old_review_body) { "Wellington was okay!" }
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
      let(:review_body) { "Wellington was great!" }

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
      let(:review_body) { "Wellington was awful!" }

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

  describe "POST #generate_review" do
    context "logged in as an admin" do
      let(:admin) { create(:user, admin: true) }
      before do
        sign_in admin
      end

      context "with special 'auto-generated content' user set up" do
        before do
          create(
            :user,
            email: "content-robot@nomadstation.io",
            password: "Pa55w0rd",
          )
        end

        it "creates an auto-generated review for the location" do
          expect{
            post generate_review_location_reviews_path(
              location_id: location.id
            )
          }.to change{ Review.count }.by 1

          expect(flash[:success_generate_review]).to eq(
            "Review auto-generated successfully"
          )
        end
      end

      context "without the special 'auto-generated content' user set up" do
        before do
          User
            .where.not(
              id: admin.id
            )
            .delete_all
        end

        it "does not create a record and sets an error" do
          expect{
            post generate_review_location_reviews_path(
              location_id: location.id
            )
          }.not_to change{ Review.count }

          expect(flash[:error_generate_review]).to eq(
            "Please create 'content-robot@nomadstation.io' account by running `rails db:seed`"
          )
        end
      end
    end

    context "logged in as a regular user" do
      before do
        sign_in user
      end

      context "with special 'auto-generated content' user set up" do
        before do
          create(
            :user,
            email: "content-robot@nomadstation.io",
            password: "Pa55w0rd",
          )
        end

        it "raises a Pundit::NotAuthorizedError" do
          expect{
            post generate_review_location_reviews_path(
              location_id: location.id
            )
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end

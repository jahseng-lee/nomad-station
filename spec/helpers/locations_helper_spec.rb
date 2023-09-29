require 'rails_helper'

RSpec.describe LocationsHelper, type: :helper do
  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end

  describe ".helper_location_description" do
    context "if location has a description" do
      let(:test_desc) { "Test description" }
      before do
        location.update!(description: test_desc)
      end

      it "returns the location description formatted" do
        desc = helper.helper_location_description(
          location: location
        )

        expect(desc).to eq simple_format(test_desc)
      end
    end

    context "if location does not have a description" do
      before do
        location.update!(description: nil)
      end

      it "returns placeholder text" do
        desc = helper.helper_location_description(
          location: location
        )

        expect(desc).to eq(
          "Make sure you put #{location.name_utf8} on your travel list!"
        )
      end
    end
  end

  describe ".helper_review_summary_star_rating" do
    context "given a location with a review_summary" do
      before do
        allow(location).to receive(:review_summary).and_return({
          overall: 4.8, # should appear as 5 full stars
          fun: 4.7, # should appear as 4.5 full stars
          cost: 4.4, # should appear as 4.5 full stars
          internet: 4.2, # should appear as 4 full stars
          safety: 0.2, # should appear as 0 full stars
        })
      end

      it "returns the average score and stars for all the review fields" do
        expect(
          helper.helper_review_summary_star_rating(
            location: location,
            review_field: :overall
          )
        ).to eq(
          "4.8 " + (ReviewHelper::STAR_FILLED * 5)
        )
        expect(
          helper.helper_review_summary_star_rating(
            location: location,
            review_field: :fun
          )
        ).to eq(
          "4.7 " + (ReviewHelper::STAR_FILLED * 4) + (ReviewHelper::STAR_HALF_FILLED * 1)
        )
        expect(
          helper.helper_review_summary_star_rating(
            location: location,
            review_field: :cost
          )
        ).to eq(
          "4.4 "+ (ReviewHelper::STAR_FILLED * 4) + (ReviewHelper::STAR_HALF_FILLED * 1)
        )
        expect(
          helper.helper_review_summary_star_rating(
            location: location,
            review_field: :internet
          )
        ).to eq(
          "4.2 " + (ReviewHelper::STAR_FILLED * 4) + (ReviewHelper::STAR_EMPTY * 1)
        )
        expect(
          helper.helper_review_summary_star_rating(
            location: location,
            review_field: :safety
          )
        ).to eq(
          "0.2 " + (ReviewHelper::STAR_EMPTY * 5)
        )
      end
    end
  end
end


require 'rails_helper'

RSpec.describe Location, type: :model do
  subject do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end
  let(:user) { create(:user) }

  describe "#review_summary" do
    context "at least 2 related reviews" do
      before do
        Review.create!(
          location: subject,
          user: user,
          overall: 5,
          fun: 5,
          cost: 5,
          internet: 5,
          safety: 5,
        )
        Review.create!(
          location: subject,
          user: user,
          overall: 5,
          fun: 4,
          cost: 3,
          internet: 2,
          safety: 1,
        )
      end

      it "gives the average of the review scores" do
        # NOTE: this test is kinda bad as it doesn't test rounding.
        #       in the actual method, we round review scores to one
        #       decimal place
        expect(subject.review_summary).to eq({
          overall: 5,
          fun: 4.5,
          cost: 4,
          internet: 3.5,
          safety: 3,
        })
      end
    end
  end
end

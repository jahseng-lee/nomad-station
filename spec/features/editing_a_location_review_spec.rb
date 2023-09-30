require 'rails_helper'

RSpec.describe "Editing a location review", type: :feature, js: true do
  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end


  describe "a user who has created a review" do
    let(:user) do
      u = User.create!(
        email: "jahseng@nomadstation.com",
        password: "Pa55w0rd"
      )

      u.confirm
      u
    end
    before do
      sign_in user

      Review.create!(
        user: user,
        location: location,
        overall: 5,
        fun: 5,
        cost: 5,
        internet: 5,
        safety: 5,
        body: "Old review body"
      )
    end

    context "on a location page" do
      before do
        visit location_path(location)
      end

      it "shows a 'Edit review' link" do
        expect(page).to have_link("Edit review")
      end

      context "clicking 'Edit review'" do
        before do
          click_link "Edit review"
        end

        it "shows the 'Edit review' form" do
          expect(page).to have_content(
            "Review for #{location.name_utf8}, #{location.country.name}"
          )

          expect(page).to have_button("Finish")
          expect(page).not_to have_content("Auto-generate review")
        end

        context "filling out the form and clicking 'Finish'" do
          let(:review_body) { "New review body" }
          before do
            select "4", from: "Overall"
            select "4", from: "Fun"
            select "4", from: "Cost"
            select "4", from: "Internet"
            select "4", from: "Safety"

            fill_in "Summary", with: review_body

            click_button "Finish"
          end

          it "saves the review to the location" do
            # Redirected successfully
            expect(page).not_to have_content(
              "Review for #{location.name_utf8}, #{location.country.name}"
            )

            expect(page).to have_content("Saved review")
            expect(page).to have_content(review_body)
          end
        end
      end
    end
  end
end


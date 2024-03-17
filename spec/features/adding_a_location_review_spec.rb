require 'rails_helper'

RSpec.describe "Adding a location review", type: :feature, js: true do
  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end


  describe "logged in as a user" do
    let(:user) { create(:user) }
    before do
      sign_in user
    end

    context "on a location's review page" do
      before do
        visit location_path(location)

        click_link "Reviews"
      end

      it "shows a 'Add review' link" do
        expect(page).to have_content(
          "No reviews yet."
        )
        expect(page).to have_link("Add review")
      end

      context "clicking 'Add review'" do
        before do
          click_link "Add review"
        end

        it "shows the 'Add review' form" do
          expect(page).to have_content(
            "Reviewing #{location.name_utf8}, #{location.country_name}"
          )

          expect(page).to have_button("Finish")
        end

        context "filling out the form and clicking 'Finish'" do
          let(:review_body) { "Wellington rocks!" }
          before do
            select "5", from: "Overall"
            select "4", from: "Fun"
            select "3", from: "Cost"
            select "2", from: "Internet"
            select "1", from: "Safety"

            fill_in "Summary", with: review_body

            click_button "Finish"
          end

          it "saves the review to the location" do
            # Redirected successfully
            expect(page).not_to have_content(
              "Reviewing #{location.name_utf8}, #{location.country_name}"
            )

            expect(page).to have_content("Saved review")
            expect(page).to have_content(review_body)
          end
        end
      end
    end
  end
end


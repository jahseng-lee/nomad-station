require 'rails_helper'

RSpec.describe "Auto-generating a location review", type: :feature, js: true do
  let(:location) { create(:location) }

  before do
    create(
      :user,
      email: "content-robot@nomadstation.io",
      password: "Pa55w0rd",
    )
  end

  describe "logged in as an admin " do
    let(:user) do
      create(:user, admin: true)
    end
    before do
      sign_in user
    end

    context "on a location page" do
      before do
        visit location_path(location)
      end

      it "shows a 'Add review' link" do
        expect(page).to have_content(
          "No reviews for #{location.name_utf8} yet"
        )
        expect(page).to have_link("Add review")
      end

      context "clicking 'Add review'" do
        before do
          click_link "Add review"
        end

        it "shows the 'Add review' form with an 'Auto-generate review' button" do
          expect(page).to have_content(
            "Review for #{location.name_utf8}, #{location.country.name}"
          )

          expect(page).to have_content("Auto-generate review")
        end

        context "clicking the 'Auto-generate review' button" do
          before do
            click_button "Auto-generate review"
          end

          it "generates a review for the location" do
            # Redirected successfully
            expect(page).not_to have_content(
              "Review for #{location.name_utf8}, #{location.country.name}"
            )

            expect(page).to have_content(
              "Review auto-generated successfully"
            )
          end
        end
      end
    end
  end
end


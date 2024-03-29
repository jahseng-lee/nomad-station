require 'rails_helper'

RSpec.describe(
  "Citizen management on profile",
  type: :feature,
  js: true
) do
  describe "logged in as a user with no citizenships" do
    let(:user) { create(:user) }
    let!(:citizenship_country) { create(:country) }
    let!(:citizenship_country_2) { create(:country, name: "Japan") }

    before do
      user.citizenships.delete_all

      sign_in user
    end

    context "visiting the profile page" do
      before do
        visit profile_path
      end

      it "shows a citizenship section without a citizenship" do
        expect(page).to have_content "Citizenship"
        expect(page).to have_content "You haven't added a citizenship."
        expect(page).to have_content("Add a citizenship now to get" \
          " tailored citizenship" \
          " information on location pages, specifically for you."
        )
      end

      context "clicking 'Add' link" do
        before do
          click_link "Add"
        end

        it "opens a modal to add a citizenship" do
          within ".modal" do
            expect(page).to have_content "Add your citizenship"
          end
        end

        context "adding a citizenship" do
          before do
            find(".choices").click
            find("div[data-value='#{citizenship_country.id}']").click

            click_button "Add"
          end

          it "adds a citizenship to the user" do
            expect(page).not_to have_content "Add your citizenship"

            expect(page).to have_content(
              "You're a citizen of" \
                " #{citizenship_country.name}"
            )
            within ".alert" do
              expect(page).to have_content(
                "Added citizenship! From now" \
                  " on, you'll see visa information specific to your" \
                  " citizenship."
              )
            end
          end

          context "updating your citizenship" do
            before do
              within "#profile-overview" do
                click_link "Update"
              end

              find(".choices").click
              find("div[data-value='#{citizenship_country_2.id}']").click

              within ".modal" do
                click_button "Update"
              end
            end

            it "updates the citizenship for the user" do
              expect(page).not_to have_content "Update your citizenship"

              expect(page).to have_content(
                "You're a citizen of" \
                  " #{citizenship_country_2.name}"
              )
            end
          end
        end
      end
    end
  end
end

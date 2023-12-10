require 'rails_helper'

RSpec.describe "Editing a location", type: :feature, js: true do
  describe "with a location in the database" do
    let(:location) { create(:location) }

    context "logged in as an admin" do
      let(:admin) do
        create(:user, admin: true)
      end
      before do
        sign_in admin
      end

      context "visiting the location page" do
        before do
          visit location_path(location)
        end

        it "shows an 'Update location' link" do
          expect(page).to have_link("Update location")
        end

        context "clicking the 'Update location' link" do
          before do
            click_link "Update location"
          end

          it "takes you to the edit location' page" do
            expect(page).to have_content(
              "Editing #{location.name}, #{location.country.name}"
            )
          end

          context "updating the location" do
            let(:new_descsription) do
              "I think Wellington is very cool"
            end
            before do
              fill_in "Description", with: new_descsription

              fill_in "Police", with: "111"
              fill_in "Ambulance", with: "222"
              fill_in "Fire", with: "333"

              click_button "Save"
            end

            it "saves the location information" do
              expect(page).to have_content(new_descsription)
              expect(page).to have_content("Updated location")

              expect(page).to have_content("Emergency numbers")
              expect(page).to have_content("Police")
              expect(page).to have_content("111")
              expect(page).to have_content("Ambulance")
              expect(page).to have_content("222")
              expect(page).to have_content("Fire")
              expect(page).to have_content("333")

              # Ensure redirect has occured
              expect(page).not_to have_content(
                "Editing #{location.name}, #{location.country.name}"
              )
            end
          end

          context "auto-generating the description" do
            before do
              click_button "Auto-generate"
            end

            it "automatically generates a description" do
              expect(page).to have_content("Auto-generation successful")

              expect(page).to have_content(
                "Editing #{location.name}, #{location.country.name}"
              )
              expect(page).to have_content(
                "This content was auto-generated. In production, this should call ChatGPT instead"
              )
            end
          end
        end
      end
    end

    context "not logged in" do
      before do
        sign_out :user
      end

      context "visiting the location page" do
        before do
          visit location_path(location)
        end

        it "does not show the 'Update location description' link" do
          expect(page).not_to have_link("Update location description")
        end
      end
    end
  end
end


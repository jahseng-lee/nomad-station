require 'rails_helper'

RSpec.describe "Editing a location", type: :feature, js: true do
  describe "with a location in the database" do
    let(:location) do
      Location.create!(
        name: "Wellington",
        name_utf8: "Wellington",
        country: Country.create!(name: "New Zealand"),
      )
    end

    context "logged in as an admin" do
      let(:admin) do
        u = User.create!(
          email: "jahseng@nomadstation.com",
          password: "Pa55w0rd",
          admin: true,
        )

        u.confirm
        u
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
            click_link 'Update location'
          end

          it "takes you to the edit location' page" do
            expect(page).to have_content(
              "Editing #{location.name}, #{location.country.name}"
            )
          end

          context "updating the description" do
            let(:new_descsription) do
              "I think Wellington is very cool"
            end
            before do
              fill_in "Description", with: new_descsription
              click_button "Save"
            end

            it "saves the description" do
              expect(page).to have_content(new_descsription)
              expect(page).to have_content("Updated location")

              # Ensure redirect has occured
              expect(page).not_to have_content(
                "Editing #{location.name}, #{location.country.name}"
              )
            end

            context "auto-generating the description" do
              pending "TODO"
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

        it "does not show the 'Update location' link" do
          expect(page).not_to have_link("Update location")
        end
      end
    end
  end
end


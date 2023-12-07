require 'rails_helper'

RSpec.describe "Adding location visa information", type: :feature, js: true do
  let(:user) do
    create(:user, admin: true)
  end
  before do
    sign_in user
  end

  describe "going to a location page with no visa information" do
    let!(:country) do
      create(:country, name: "New Zealand")
    end
    let!(:location) do
      create(
        :location,
        name: "Wellington",
        country: country
      )
    end

    before do
      visit "/"

      click_link "Wellington"
      click_link "Visas"
    end

    it "shows a 'no information' message" do
      expect(page).to have_content(
        "No visa information for #{country.name} yet"
      )
    end

    context "clicking on 'Edit'" do
      before do
        click_link "Add visas summary"
      end

      it "shows the page to add visa summary for the country" do
        expect(page).to have_content(
          "Adding visa summary for #{country.name}"
        )
      end

      context "filling out the form and clicking 'Save'" do
        let(:visa_info) do
          "Visa summary with **bold text**"
        end

        before do
          fill_in "country_visa_summary_information", with: visa_info

          click_button "Save"
        end

        it "shows the visa summary on the location page" do
          expect(page).to have_content(
            "Visa summary with bold text"
          )
          # NOTE capybara doesn't wait for `current_path`, which is
          #      gross as. Use #have_content first to make it wait
          expect(page.current_path).to eq(
            location_visa_information_path(location_id: location.id)
          )
        end
      end
    end

    context "clicking 'Add a visa'" do
      before do
        click_link "Add a visa"
      end

      it "takes you to a page to add a visa" do
        expect(page).to have_content("Adding a visa for #{country.name}")
      end

      context "adding a name, multiple eligible countries then clicking 'Save'" do
        let(:visa_name) { "90 day visa exemption" }
        let!(:country_1) do
          create(
            :country,
            name: "Malaysia"
          )
        end
        let!(:country_2) do
          create(
            :country,
            name: "Germany"
          )
        end
        before do
          fill_in "visa_name", with: visa_name
          click_button "Add visa"
        end

        it "shows the visa" do
          expect(page).to have_content("#{visa_name} for #{country.name}")

          # NOTE capybara doesn't wait for `current_path`, which is
          #      gross as. Use #have_content first to make it wait
          expect(page.current_path).to eq(
            edit_country_location_visa_path(
              Visa.last,
              country_id: country.id,
              location_id: location.id
            )
          )
        end

        context "adding multiple countries to the visa" do
          before do
            fill_in "search-countries", with: "Malay"
            click_button "Malaysia"

            expect(page).to have_content "Malaysia"

            fill_in "search-countries", with: "Germa"
            click_button "Germany"

            expect(page).to have_content "Germany"

            click_link "Back to location"
          end

          it "shows the visa name and eligible countries on the visa information page" do
            expect(page).to have_content("#{visa_name}")
            expect(page).to have_content(country_1.name)
            expect(page).to have_content(country_2.name)
          end

          context "clicking on the 'Remove visa' button" do
            before do
              find('a[aria-label="Edit visa"]').click
              accept_confirm do
                click_button "Delete"
              end
            end

            it "removes the visa" do
              expect(page).not_to have_content(visa_name)
              expect(page).not_to have_content(country_1.name)
              expect(page).not_to have_content(country_2.name)
            end
          end

          context "clicking on the 'Edit visa' link" do
            before do
              find('a[aria-label="Edit visa"]').click
            end

            it "takes you to the 'Edit visa' page" do
              expect(page).to have_content(
                "#{visa_name} for #{country.name}"
              )
            end
          end
        end
      end
    end
  end
end

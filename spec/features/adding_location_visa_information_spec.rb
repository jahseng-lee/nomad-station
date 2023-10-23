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
        click_link "Add visa information"
      end

      it "shows the page to add visa information for the country" do
        expect(page).to have_content(
          "Adding visa information for #{country.name}"
        )
      end

      context "filling out the form and clicking 'Save'" do
        let(:visa_info) do
          "Visa information with **bold text**"
        end

        before do
          fill_in "country_visa_information", with: visa_info

          click_button "Save"
        end

        it "shows the visa information on the location page" do
          expect(page).to have_content(
            "Visa information with bold text"
          )
          # NOTE capybara doesn't wait for `current_path`, which is
          #      gross as. Use #have_content first to make it wait
          expect(page.current_path).to eq(
            location_visa_information_path(location_id: location.id)
          )
        end
      end
    end
  end
end

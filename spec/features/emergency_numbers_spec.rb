require 'rails_helper'

RSpec.describe "Emergency numbers", type: :feature, js: true do
  describe "logged in as an admin on a location page" do
    let(:admin) { create(:user, admin: true) }
    let(:location) { create(:location, country: country) }
    let(:country) { create(:country) }

    before do
      sign_in admin

      visit location_path(location)
    end

    it "renders the 'Add emergency info' link" do
      expect(page).to have_content "Add emergency info."
    end

    context "clicking on the 'Add emergency info' link" do
      before do
        click_link "Add emergency info."
      end

      it "takes you to a page to add emergency info" do
        expect(page).to have_content(
          "Emergency info. for #{country.name}"
        )
      end

      context "filling out the form and submitting" do
        before do
          fill_in "Police", with: "111"
          fill_in "Ambulance", with: "222"
          fill_in "Fire", with: "333"

          click_button "Save"
        end

        it "saves and displays the info" do
          expect(page).to have_content("Emergency numbers")
          expect(page).to have_content("Police")
          expect(page).to have_content("111")
          expect(page).to have_content("Ambulance")
          expect(page).to have_content("222")
          expect(page).to have_content("Fire")
          expect(page).to have_content("333")
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "User specific visas", type: :feature, js: true do
  let(:user) { create(:user) }
  let!(:nz) { create(:country, name: "New Zealand") }
  let!(:aus) { create(:country, name: "Australia") }
  let!(:england) { create(:country, name: "England") }
  let!(:location) do
    create(
      :location,
      name: "Wellington",
      country: nz
    )
  end

  before { sign_in user }

  describe "a user who has set up their citizenships" do
    before do
      visit root_path
      click_link "Profile"

      click_link "Add citizenship"
      fill_in "search-countries", with: "Austr"
      click_button "Australia"

      click_link "Add citizenship"
      fill_in "search-countries", with: "Eng"
      click_button "England"
    end

    context "visiting a location page with visas for the user" do
      before do
        # TODO create an NZ visa for Australians
        # TODO create an NZ visa for the English
        # TODO create an NZ visa for Malaysians
        # TODO visit the Visas page for Wellington
      end

      it "shows the relevant visas for the user only" do
        pending "TODO"
      end

      context "if the user clicks 'Show all visas'" do
        before do
          click_link "Show all visa"
        end

        it "shows all available visa" do
          pending "TODO"
        end
      end
    end

    context "visiting a location with no visas for the user" do
      let(:antarctica) { create(:country, name: "Antarctica") }
      let!(:location) do
        create(
          :location,
          name: "Club penguin",
          country: antarctica
        )
      end

      before do
        # TODO create a visa for Malaysians only
        # TODO visit the Visas page for Club penguin
      end

      it "shows a message showing no relevant visas" do
        expect(page).to have_content(
          "We can't find any visas for any of your listed citizenships."
        )
      end

      it "shows all available visa" do
        pending "TODO"
      end
    end
  end

  describe "a user who has not set up their citizenships" do
    before do
      user.citizenships.delete_all
    end

    context "visiting a location page with visas for the user" do
      before do
        # TODO create a visa for Australians
        # TODO create a visa for the English
        # TODO create a visa for Malaysians
        # TODO visit the Visas page for Wellington
      end

      it "shows all available visa" do
        pending "TODO"
      end
    end
  end
end

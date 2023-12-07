require 'rails_helper'

RSpec.describe "User specific visas", type: :feature, js: true do
  let(:user) { create(:user) }
  let(:nz) { create(:country, name: "New Zealand") }
  let!(:aus) { create(:country, name: "Australia") }
  let!(:england) { create(:country, name: "England") }
  let!(:malaysia) { create(:country, name: "Malaysia") }
  let!(:wellington) do
    create(
      :location,
      name: "Wellington",
      country: nz
    )
  end

  before { sign_in user }

  def setup_visas
    # create an NZ visa for Australians
    visa = create(:visa, name: "Visa for #{aus.name}", country: nz)
    create(
      :eligible_countries_for_visa,
      visa: visa,
      eligible_country: aus
    )
    # create an NZ visa for the English
    visa = create(:visa, name: "Visa for #{england.name}", country: nz)
    create(
      :eligible_countries_for_visa,
      visa: visa,
      eligible_country: england
    )
    # create an NZ visa for Malaysians
    visa = create(
      :visa,
      name: "Visa for #{malaysia.name}",
      country: nz
    )
    create(
      :eligible_countries_for_visa,
      visa: visa,
      eligible_country: malaysia
    )
  end

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
        setup_visas

        visit location_visa_information_path(wellington)
      end

      it "shows the relevant visas for the user only", :aggregate_failures do
        expect(page).to have_content("Visa for #{aus.name}")
        expect(page).to have_content("Visa for #{england.name}")

        expect(page).not_to have_content("Visa for #{malaysia.name}")
      end
    end

    context "visiting a location with no visas for the user" do
      let(:antarctica) { create(:country, name: "Antarctica") }
      let!(:club_penguin) do
        create(
          :location,
          name: "Club penguin",
          country: antarctica
        )
      end

      before do
        # create an NZ visa for Malaysians
        visa = create(
          :visa,
          name: "Visa for #{malaysia.name}",
          country: antarctica
        )
        create(
          :eligible_countries_for_visa,
          visa: visa,
          eligible_country: antarctica
        )

        visit location_visa_information_path(club_penguin)
      end

      it "shows a message showing no relevant visas" do
        expect(page).to have_content(
          "We can't find any visas for any of your listed citizenships"
        )
      end
    end
  end

  describe "a user who has not set up their citizenships" do
    before do
      user.citizenships.delete_all
    end

    context "visiting a location page with visas for the user" do
      before do
        setup_visas

        visit location_visa_information_path(wellington)
      end

      it "shows all available visa" do
        expect(page).to have_content("Go to your profile page to add")

        expect(page).to have_content("Visa for #{aus.name}")
        expect(page).to have_content("Visa for #{england.name}")
        expect(page).to have_content("Visa for #{malaysia.name}")
      end
    end
  end
end

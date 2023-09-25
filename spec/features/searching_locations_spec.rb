require 'rails_helper'

RSpec.describe "Navbar", type: :feature, js: true do
  describe "having some regions, countries and locations set up" do
    let(:oceania) { Region.create!(name: "Oceania") }
    let(:se_asia) { Region.create!(name: "South-east asia") }
    before do
      nz = Country.create!(name: "New Zealand", region: oceania)
      thailand = Country.create!(name: "Thailand", region: se_asia)

      Location.create!(
        name: "Wellington",
        name_utf8: "Wellington",
        country: nz
      )
      Location.create!(
        name: "Bangkok",
        name_utf8: "Bangkok",
        country: thailand
      )

      visit root_path
    end

    describe "selecting a region" do
      before do
        # Select 'Oceania' option
        find("select[aria-label='Region select']")
          .find(:option, oceania.name)
          .select_option
      end

      it "filters results based on region" do
        expect(page).to have_text("New Zealand")
        expect(page).not_to have_text("Bangkok")
      end
    end
  end
end


require 'rails_helper'

RSpec.describe "Navbar", type: :feature, js: true do
  describe "having some regions, countries and locations set up" do
    let(:oceania) { Region.create!(name: "Oceania") }
    let(:se_asia) { Region.create!(name: "South-east asia") }

    let(:nz) { create(:country, name: "New Zealand", region: oceania) }
    let(:thailand) { create(:country, name: "Thailand", region: se_asia) }
    let(:aus) { create(:country, name: "Australia", region: oceania) }

    before do
      create(
        :location,
        name: "Wellington",
        name_utf8: "Wellington",
        country: nz
      )
      create(
        :location,
        name: "Auckland",
        name_utf8: "Auckland",
        country: nz
      )
      create(
        :location,
        name: "Melbourne",
        name_utf8: "Melbourne",
        country: aus
      )
      create(
        :location,
        name: "Bangkok",
        name_utf8: "Bangkok",
        country: thailand
      )

      visit root_path
    end

    context "selecting a region" do
      before do
        # Select 'Oceania' option
        find("select[aria-label='Region select']")
          .find(:option, oceania.name)
          .select_option
      end

      it "filters results based on region" do
        expect(page).to have_text("Wellington")
        expect(page).to have_text("Auckland")
        expect(page).to have_text("Melbourne")

        expect(page).not_to have_text("Bangkok")
      end

      context "select a country within the region" do
        before do
          # Select 'Oceania' option
          find("select[aria-label='Country select']")
            .find(:option, nz.name)
            .select_option
        end

        it "filters results based on country" do
          expect(page).to have_text("Wellington")
          expect(page).to have_text("Auckland")

          expect(page).not_to have_text("Melbourne")
          expect(page).not_to have_text("Bangkok")
        end

        context "searching with filters applied" do
          before do
            fill_in "search_query", with: "Well"
            find("#search_query").send_keys(:enter)
          end

          it "applies the search correctly" do
            expect(page).to have_text("Wellington")

            expect(page).not_to have_text("Auckland")
            expect(page).not_to have_text("Melbourne")
            expect(page).not_to have_text("Bangkok")
          end
        end
      end
    end
  end
end


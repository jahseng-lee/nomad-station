require 'rails_helper'

RSpec.describe "SearchLocations", type: :request do
  describe "GET /index" do
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
      end

      context "with a region_id" do
        let(:params) do
          {
            search: {
              region_id: oceania.id
            }
          }
        end

        it "returns locations related to the region" do
          get search_locations_path(params: params)

          expect(response.body.include?("Wellington")).to eq true
          expect(response.body.include?("Melbourne")).to eq true

          expect(response.body.include?("Bangkok")).to eq false
        end

        context "with a region_id and country_id" do
          let(:params) do
            {
              search: {
                region_id: oceania.id,
                country_id: nz.id,
              }
            }
          end

          it "returns locations related to the region and country" do
            get search_locations_path(params: params)

            expect(response.body.include?("Wellington")).to eq true

            expect(response.body.include?("Melbourne")).to eq false
            expect(response.body.include?("Bangkok")).to eq false
          end
        end
      end
    end
  end
end

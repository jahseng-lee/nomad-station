require 'rails_helper'

RSpec.describe "Filtering by tags", type: :feature, js: true do
  describe "with locations that have been tagged" do
    let(:tag_1) { create(:tag, name: "Tag 1") }
    let(:tag_2) { create(:tag, name: "Tag 2") }
    let(:tag_3) { create(:tag, name: "Tag 3") }

    let!(:location_1) do
      l = create(:location, name_utf8: "Location with tags 1 & 3")
      l.tags << tag_1
      l.tags << tag_3
      l
    end
    let!(:location_2) do
      l = create(:location, name_utf8: "Location with tag 2 only")
      l.tags << tag_2
      l
    end
    let!(:location_3) do
      l = create(:location, name_utf8: "Location with tag 3 only")
      l.tags << tag_3
      l
    end

    before do
      visit root_path
    end

    it "shows the locations with their relevant tags" do
      expect(page).to have_content(location_1.name_utf8)
      expect(page).to have_content(location_2.name_utf8)
      expect(page).to have_content(location_3.name_utf8)
    end

    it "shows the tag links" do
      within ".tag-filter-links" do
        expect(page).to have_link(tag_1.name)
        expect(page).to have_link(tag_2.name)
        expect(page).to have_link(tag_3.name)
      end
    end

    context "clicking the first tag's filter link" do
      before do
        within ".tag-filter-links" do
          click_link tag_1.name
        end
      end

      it "only shows the locations with the first tag" do
        expect(page).to have_content(location_1.name_utf8)
        expect(page).not_to have_content(location_2.name_utf8)
        expect(page).not_to have_content(location_3.name_utf8)
      end

      context "clicking the second tag's filter link" do
        before do
          within ".tag-filter-links" do
            click_link tag_2.name
          end
        end

        it "only shows the locations with either the first or second tag" do
          expect(page).to have_content(location_1.name_utf8)
          expect(page).to have_content(location_2.name_utf8)
          expect(page).not_to have_content(location_3.name_utf8)
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Deleting a location", type: :feature, js: true do
  let(:location) { create(:location) }

  describe "logged in as an admin " do
    let(:user) do
      create(:user, admin: true)
    end
    before do
      sign_in user
    end

    context "on a location page" do
      before do
        visit location_path(location)
      end

      it "has a 'Delete' button" do
        expect(page).to have_button "Delete"
      end

      context "clicking the 'Delete' button" do
        before do
          accept_confirm do
            click_button "Delete"
          end
        end

        it "deletes the location" do
          expect(current_path).to eq "/"
          expect(page).to have_content "Location '#{location.name}' deleted"

          fill_in "search_query", with: location.name
          within "search-results" do
            expect(page).not_to have_content location.name
          end
        end
      end
    end
  end

  shared_examples "an admin secured action" do
    it "does not show the 'Delete' button" do
      expect(page).not_to have_button "Delete"
    end
  end

  describe "logged in as non-admin" do
    let(:user) do
      create(:user, admin: false)
    end
    before do
      sign_in user
    end

    it_behaves_like "an admin secured action"
  end

  describe "not logged in" do
    before do
      sign_out :user
    end

    it_behaves_like "an admin secured action"
  end
end

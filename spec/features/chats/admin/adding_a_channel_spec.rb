require 'rails_helper'

RSpec.describe "Adding a chat channel", type: :feature, js: true do
  before do
    visit root_path
  end

  describe "logged in as an admin" do
    before do
      sign_in create(:user, admin: true)
    end

    context "visiting the chat page" do
      before do
        click_link "Chat"
      end

      it "shows the 'Add channel' link" do
        expect(page).to have_link("Add channel")
      end

      context "clicking the 'Add channel' link" do
        before do
          click_link 'Add channel'
        end

        it "takes you to the new channel page" do
          expect(page).to have_content "Adding a new channel"
        end

        context "filling out the form and clicking 'Add channel'" do
          let(:new_channel_name) { "New channel" }
          before do
            # TODO fill in new channel name
            click_button "Add channel"
          end

          it "creates a new channel" do
            expect(page).to have_content("New channel")
          end
        end
      end
    end
  end

  describe "logged in as a non-admin" do
    before do
      sign_in create(:user, admin: false)
    end

    context "visiting the chat page" do
      before do
        click_link "Chat"
      end

      it "does not show the 'Add channel' link" do
        expect(page).not_to have_link("Add channel")
      end
    end
  end
end

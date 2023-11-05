require 'rails_helper'

RSpec.describe "Leaving a channel", type: :feature, js: true do
  describe "logged in as regular user with default channels set up" do
    before do
      ChatsFeatureHelper.setup_default_channels

      sign_in create(:user)
    end

    context "visiting the Chat page" do
      before do
        visit "/"

        click_link "Chat"
      end

      it "shows the default channels" do
        expect(page).to have_link("General")
        expect(page).to have_link("Feedback and requests")
        expect(page).to have_link("Bugs")
      end

      context "clicking on the 'General' chat" do
        before do
          click_link "General"
        end

        it "shows the channel" do
          within ".channel-header" do
            expect(page).to have_content("General")
          end
        end

        context "clicking on the 'Leave channel' button" do
          before do
            find('button[aria-label="Channel settings"]').click

            accept_confirm do
              click_button "Leave channel"
            end
          end

          it "removes the user from the channel" do
            expect(page).not_to have_content("General")
            expect(page).not_to have_link("General")
          end
        end
      end
    end
  end
end

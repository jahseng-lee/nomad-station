require 'rails_helper'

RSpec.describe "Joining a channel", type: :feature, js: true do
  describe "logged in as regular user with a new channel set up" do
    let(:new_channel_name) { "New channel" }
    before do
      ChatsFeatureHelper.setup_default_channels
      create(:channel, name: new_channel_name)

      sign_in create(:user)
    end

    context "visiting the Chat page" do
      before do
        visit "/"

        click_link "Chat"
      end

      it "shows the 'Join channel' link" do
        expect(page).to have_link "Join channel"
      end

      context "clicking the 'Join channel' button" do
        before do
          click_link "Join channel"
        end

        it "replaces the channel list with a list of searchable channels" do
          expect(page).not_to have_content("General")
          expect(page).not_to have_content("Feedback and requests")
          expect(page).not_to have_content("Bugs")

          expect(page).to have_content(new_channel_name)
        end

        context "searching for a channel then clicking on it" do
          before do
            fill_in "filter", with: "new c"

            click_link new_channel_name
            click_button "Join channel"
          end

          it "adds you to the channel" do
            within ".channel-header" do
              expect(page).to have_content(new_channel_name)
            end

            # Regular channel list appears
            expect(page).to have_link("General")
            expect(page).to have_link("Feedback and requests")
            expect(page).to have_link("Bugs")
          end
        end
      end
    end
  end
end

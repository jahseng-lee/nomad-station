require 'rails_helper'

RSpec.describe "Sending a message", type: :feature, js: true do
  describe "logged in as regular user with default channels set up" do
    before do
      # TODO should probably refactor this into a helper method
      create(:channel, name: "General")
      create(:channel, name: "Feedback and requests")
      create(:channel, name: "Bugs")

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

        context "filling out the message form and clicking 'Send'" do
          let(:new_message) { "My first message!" }

          before do
            fill_in "Type message...", with: new_message
            click_button "Send"
          end

          it "send the message to the chat" do
            within ".chat-message-section" do
              expect(page).to have_content(new_message)
            end
          end

          context "clicking the delete message button" do
            before do
              find(".chat-message-current-user").hover
              accept_confirm do
                find('button[aria-label="Delete message"]').click
              end
            end

            it "shows a 'Deleted message' message" do
              expect(page).to have_content "Deleted message"
            end
          end
        end
      end
    end
  end
end

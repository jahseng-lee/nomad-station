require 'rails_helper'

RSpec.describe "Sending a message", type: :feature, js: true do
  describe "logged in as regular user with default channels set up" do
    before do
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
    end
  end
end

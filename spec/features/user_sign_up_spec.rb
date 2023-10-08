require 'rails_helper'

RSpec.describe "User sign up", type: :feature, js: true do
  describe "on the home page" do
    context "clicking the Sign Up link" do
      before do
        visit "/"

        click_link "Sign up"
      end

      it "takes you to the registration page" do
        expect(page).to have_content "Sign up"
      end

      context "filling out the form and signing up" do
        let(:email) { "heian-era-rocks@gmail.com" }
        let(:password) { "GojoIsAFraud" }
        before do
          fill_in "Display name", with: "Ryomen Sukuna"
          fill_in "Email", with: email
          fill_in "Password", with: password

          expect(DeviseMailer)
            .to receive(:confirmation_instructions)
            .and_call_original

          click_button "Sign up"
        end

        it "sends an email and notifies the user" do
          expect(page).to have_content("Sign in")
          expect(page).to have_content(I18n.t(
            "devise.registrations.signed_up_but_unconfirmed"
          ))
        end

        context "after user confirms and signs in" do
          before do
            sleep(1) # This is disgusting, but for some reason
                     # the user isn't created until I sleep or
                     # byebug...
            user = User.last
            user.confirm

            fill_in "Email", with: email
            fill_in "Password", with: password

            click_button "Sign in"
          end

          it "takes them to a home page with a welcome message and billing information" do
            expect(page).to have_content("Nomadstation monthly membership")
            expect(page).to have_content("$8 a month")
          end
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Location visas", type: :feature, js: true do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  let(:country) { location.country }

  let(:citizenship) { create(:country) }
  let(:other_citizenship) { create(:country, name: "Westeros") }

  let(:generic_visa_info) do
    "Generic information for non-users and users with no citizenships"
  end
  let(:citizenship_visa_info) do
    "Citizenship information for our logged in boi"
  end

  before do
    country.visa_informations << create(
      :visa_information,
      country: country,
      citizenship: nil,
      body: generic_visa_info
    )
    country.visa_informations << create(
      :visa_information,
      country: country,
      citizenship: citizenship,
      body: citizenship_visa_info
    )
    country.visa_informations << create(
      :visa_information,
      country: country,
      citizenship: other_citizenship,
      body: "Citizenship information no one :("
    )
  end

  describe "non-user" do
    before do
      sign_out :user
    end

    context "visiting a location page with visa information" do
      before do
        visit location_path(location)

        click_link "Visas"
      end

      it "shows the generic visa information for a location" do
        expect(page).to have_content generic_visa_info
      end

      it "shows the alert for getting customised visa information" do
        within ".alert" do
          expect(page).to have_content(
            "You're seeing generic visa information for" \
            " #{country.name}. Add a citizenship to your profile to get" \
            " specific visa information for you."
          )
        end
      end

      context "clicking on the link to add citizenship" do
        before do
          click_link "Add a citizenship to your profile"
        end

        it "takes them to the sign up page" do
          expect(page).to have_current_path(new_user_registration_path)
        end
      end

      context "clicking on the link to 'Report issue'" do
        before do
          click_link "Report issue"
        end

        it "takes them to the sign up page" do
          expect(page).to have_current_path(new_user_registration_path)
        end
      end
    end
  end

  describe "logged in" do
    before do
      sign_in user
    end

    context "visiting a location page with visa information" do
      before do
        visit location_path(location)

        click_link "Visas"
      end

      it "shows the generic visa information for a location" do
        expect(page).to have_content generic_visa_info
      end

      it "shows the alert for getting customised visa information" do
        within ".alert" do
          expect(page).to have_content(
            "You're seeing generic visa information for" \
            " #{country.name}. Add a citizenship to your profile to get" \
            " specific visa information for you."
          )
        end
      end

      context "clicking on the link to add citizenship" do
        before do
          click_link "Add a citizenship to your profile"
        end

        it "opens a modal to add a citizenship" do
          within ".modal" do
            expect(page).to have_content "Add your citizenship"
          end
        end

        context "adding a citizenship" do
          before do
            find(".choices").click
            find("div[data-value='#{citizenship.id}']").click

            click_button "Add"
          end

          it "dismisses the modal and shows citizenship specific information" do
            expect(page).not_to have_content "Add your citizenship"

            expect(page).to have_content citizenship_visa_info
            within ".alert" do
              expect(page).to have_content "Added citizenship! From now" \
                " on, you'll see visa information specific to your" \
                " citizenship."
            end
          end

          context "clicking on the link to 'Report issue'" do
            before do
              click_link "Report issue"
            end

            it "opens a modal to report an issue" do
              within ".modal" do
                expect(page).to have_content "Report issue"
              end
            end

            context "filling out the form and submitting" do
              before do
                select "Incorrect visa information", from:
                  "issue_issue_type"
                fill_in "issue_body", with:
                  "I'm the US president. I can travel anywhere"

                click_button "Report"
              end

              it "logs an issue" do
                expect(page).to have_content "Thanks for reporting the" \
                  " issue. Our team will look into it ASAP."

                sign_out :user

                # Sign in as user
                admin = create(:user, admin: true)
                sign_in admin
                visit root_path

                click_link "Issues"

                expect(page).to have_content "Incorrect visa information"
              end
            end
          end
        end
      end
    end
  end
end


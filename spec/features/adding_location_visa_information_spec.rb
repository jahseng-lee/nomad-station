require 'rails_helper'

RSpec.describe "Adding location visa information", type: :feature, js: true do
  let(:user) do
    create(:user, admin: true)
  end
  before do
    sign_in user
  end

  describe "going to a location page with no visa information" do
    let!(:country) do
      # TODO refactor all existing Country.create in test
      create(:country, name: "New Zealand")
    end
    let!(:location) do
      # TODO refactor all existing Location.create in test
      create(
        :location,
        name: "Wellington",
        country: country
      )
    end

    before do
      visit "/"

      click_link "Wellington"
      click_link "Visas"
    end

    it "shows a 'no information' message" do
      expect(page).to have_content(
        "No visa information for #{country.name} yet."
      )
    end

    context "clicking on 'Edit'" do
      pending "TODO"
    end
  end
end

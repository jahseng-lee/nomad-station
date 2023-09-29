require 'rails_helper'

RSpec.describe LocationsHelper, type: :helper do
  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end

  describe ".helper_location_description" do
    context "if location has a description" do
      let(:test_desc) { "Test description" }
      before do
        location.update!(description: test_desc)
      end

      it "returns the location description formatted" do
        desc = helper.helper_location_description(
          location: location
        )

        expect(desc).to eq simple_format(test_desc)
      end
    end

    context "if location does not have a description" do
      before do
        location.update!(description: nil)
      end

      it "returns placeholder text" do
        desc = helper.helper_location_description(
          location: location
        )

        expect(desc).to eq(
          "Make sure you put #{location.name_utf8} on your travel list!"
        )
      end
    end
  end
end


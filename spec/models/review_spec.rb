require 'rails_helper'

RSpec.describe Review, type: :model do
  subject do
    described_class.new(
      user: user,
      location: location,

      body: "",
      overall: overall,
      fun: fun,
      cost: cost,
      internet: internet,
      safety: safety,
    )
  end
  let(:user) { create(:user) }
  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end
  let(:overall) { 5 }
  let(:fun) { 4 }
  let(:cost) { 3 }
  let(:internet) { 2 }
  let(:safety) { 1 }

  describe "#validations" do
    context "with valid arguments" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "with an integer field higher than 5" do
      let(:overall) { 6 }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "with an integer field lower than 1" do
      let(:cost) { 0 }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end
  end
end

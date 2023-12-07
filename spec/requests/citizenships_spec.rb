require 'rails_helper'

RSpec.describe "Citizenships", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid params" do
      let(:country) { create(:country) }

      it "creates a new Citizenship for the current user and specified country" do
        expect{
          post citizenships_path(format: :turbo_stream),
          params: { citizenship: { country_id: country.id } }
        }
          .to change{ user.citizenships.count }
          .by 1

        expect(user.citizenships.last.country).to eq country
      end
    end

    context "specifying a country that doesn't exist" do
      before do
        Country.delete_all
      end

      it "does not create a Citizenship" do
        expect{
          post citizenships_path(format: :turbo_stream),
          params: { citizenship: { country_id: 1 } }
        }
          .not_to change{ user.citizenships.count }
      end
    end
  end
end

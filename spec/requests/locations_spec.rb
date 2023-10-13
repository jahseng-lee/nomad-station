require 'rails_helper'

RSpec.describe "Locations", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:location) do
    Location.create!(
      name: "Wellington",
      name_utf8: "Wellington",
      country: Country.create!(name: "New Zealand"),
    )
  end

  describe "GET #show" do
    it "returns http success" do
      get location_path(location)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    context "signed in as an admin" do
      before do
        sign_in admin
      end

      it "returns http success" do
        get edit_location_path(location)

        expect(response).to have_http_status(:success)
      end
    end

    context "not signed in" do
      before do
        sign_out :user
      end

      it "returns http redirect" do
        get edit_location_path(location)

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "POST #update" do
    context "with valid params" do
      let(:new_descsription) do
        "I think Wellington is very cool"
      end
      let(:params) do
        {
          location: {
            description: new_descsription
          }
        }
      end

      context "signed in as an admin" do
        before do
          sign_in admin
        end

        it "updates the location with the description" do
          put location_path(location), params: params

          location.reload
          expect(location.description).to eq new_descsription
        end
      end

      context "not signed in" do
        before do
          sign_out :user
        end

        it "returns http redirect" do
          put location_path(location), params: params

          expect(response).to have_http_status(:redirect)
        end
      end
    end
  end

  describe "PATCH #generate_description" do
    context "signed in as an admin" do
      before do
        sign_in admin
      end

      it "updates the location with an 'auto-generated' description" do
        patch generate_description_location_path(location)

        location.reload
        expect(location.description).to eq(
          "This content was auto-generated. In production, this should call ChatGPT instead"
        )
      end
    end

    context "not signed in" do
      before do
        sign_out :user
      end

      it "returns http redirect" do
        patch generate_description_location_path(location)

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end


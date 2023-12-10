require 'rails_helper'

RSpec.describe "Locations", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:location) { create(:location) }

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
      let(:new_descsription) { "I think #{location.name} is very cool" }
      let(:ambulance_number) { "111" }
      let(:police_number) { "222" }
      let(:fire_number) { "333" }
      let(:params) do
        {
          location: {
            description: new_descsription,
            ambulance_number: ambulance_number,
            police_number: police_number,
            fire_number: fire_number,
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
          expect(location.ambulance_number).to eq ambulance_number
          expect(location.police_number).to eq police_number
          expect(location.fire_number).to eq fire_number
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


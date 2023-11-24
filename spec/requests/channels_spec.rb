require 'rails_helper'

RSpec.describe "Channels", type: :request do
  describe "#new" do
    context "logged in as an admin" do
      before do
        sign_in create(:user, admin: true)
      end

      it "returns a 200 OK" do
        get new_channel_path

        expect(response.status).to eq 200
      end
    end

    context "logged in as a normal user" do
      before do
        sign_in create(:user, admin: false)
      end

      it "raises a Pundit::NotAuthorizedError" do
        expect{ get new_channel_path }.to raise_error(
          Pundit::NotAuthorizedError
        )
      end
    end
  end

  describe "#create" do
    let(:params) do
      {
        channel: {
          name: name
        }
      }
    end
    let(:name) { "Awesome chat channel" }

    context "logged in as an admin" do
      before do
        sign_in create(:user, admin: true)
      end

      it "creates a new channel with the specified name" do
        expect{ post channels_path, params: params }.to change{
          Channel.count
        }.by 1

        channel = Channel.last

        expect(channel.name).to eq name
        expect(response.location).to eq chat_url
      end
    end

    context "logged in as a normal user" do
      before do
        sign_in create(:user, admin: false)
      end

      it "raises a Pundit::NotAuthorizedError" do
        expect{ post channels_path, params: params }.to raise_error(
          Pundit::NotAuthorizedError
        )
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "ChannelMessages", type: :request do
  let(:user) { create(:user) }
  let(:channel) { create(:channel, name: "Test channel") }
  before do
    ChannelMember.create!(
      chat_channel: channel,
      user: user
    )
  end
  before do
    sign_in user
  end

  describe "#create" do
    context "with valid params" do
      let(:message_body) { "A new chat message" }
      let(:params) do
        {
          channel_message: {
            body: message_body
          }
        }
      end

      it "creates a new message" do
        expect{
          post channel_channel_messages_path(
            channel_id: channel.id,
            format: :turbo_stream
          ),
          params: params
        }.to change{ channel.messages.count }.by 1

        message = ChannelMessage.last

        expect(message.body).to eq message_body
        expect(message.sender).to eq user
      end
    end
  end

  describe "#destroy" do
    context "on a message you own" do
      let!(:message) do
        ChannelMessage.create!(
          channel: channel,
          sender: user,
          body: "Test"
        )
      end

      it "updates the message as 'deleted'" do
        delete channel_channel_message_path(
          message,
          channel_id: channel.id,
          format: :turbo_stream
        )

        message.reload

        expect(message).to be_deleted
      end
    end

    context "on a message you don't own" do
      let!(:message) do
        ChannelMessage.create!(
          channel: channel,
          sender: create(:user),
          body: "Test"
        )
      end

      it "raises an exception" do
        expect{ delete channel_channel_message_path(
            message,
            channel_id: channel.id,
            format: :turbo_stream
          )
        }.to raise_exception(ActiveRecord::RecordNotFound)

        message.reload

        expect(message).not_to be_deleted
      end
    end
  end
end

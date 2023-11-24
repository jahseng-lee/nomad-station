require 'rails_helper'

module ChatsFeatureHelper
  def self.setup_default_channels
    FactoryBot.create(:channel, name: "General")
    FactoryBot.create(:channel, name: "Feedback and requests")
    FactoryBot.create(:channel, name: "Bugs")
  end
end

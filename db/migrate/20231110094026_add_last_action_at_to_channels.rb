class AddLastActionAtToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :last_action_at, :datetime
  end
end

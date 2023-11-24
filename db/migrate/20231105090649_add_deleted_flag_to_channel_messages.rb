class AddDeletedFlagToChannelMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :channel_messages, :deleted, :boolean, default: false
  end
end

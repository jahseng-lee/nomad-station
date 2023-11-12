class AddIndexToMessagesCreatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :channel_messages, :created_at
  end
end

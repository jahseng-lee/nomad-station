class RemoveStreamChatColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :stream_user_id, :text
    remove_column :users, :stream_user_token, :text
  end
end

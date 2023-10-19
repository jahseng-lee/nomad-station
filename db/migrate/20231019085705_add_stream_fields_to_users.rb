class AddStreamFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stream_user_id, :text
    add_column :users, :stream_user_token, :text
  end
end

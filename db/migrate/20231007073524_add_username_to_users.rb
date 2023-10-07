class AddUsernameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :display_name, :text

    # This is arbitrary, just make sure users have a username
    User.find_each do |user|
      display_name = user.email.split("@").first
      user.update!(display_name: display_name)
    end

    change_column_null :users, :display_name, false
  end
end

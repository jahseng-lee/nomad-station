class AddLastActiveToChannelMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :channel_members, :last_active, :datetime
  end
end

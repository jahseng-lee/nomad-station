class CreateChannelMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_members do |t|
      t.references :user, null: false, index: true
      t.references :channel, null: false, index: true

      t.timestamps
    end
  end
end

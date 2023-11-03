class CreateChannelMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_messages do |t|
      t.text :body, null: false

      t.references :channel, null: false, index: true
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end

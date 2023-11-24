class AddReplyToOnMessages < ActiveRecord::Migration[7.0]
  def change
    change_table :channel_messages do |t|
      t.references :reply_to, null: true, foreign_key: {
        to_table: :channel_messages
      }
    end
  end
end

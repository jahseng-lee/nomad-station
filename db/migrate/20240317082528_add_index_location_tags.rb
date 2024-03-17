class AddIndexLocationTags < ActiveRecord::Migration[7.0]
  def change
    add_index :locations_tags, [:location_id, :tag_id], unique: true
    add_index :locations_tags, :tag_id
  end
end

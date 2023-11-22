class CreateProfilePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_pictures do |t|
      t.references :user, null: false
      t.jsonb :image_data

      t.timestamps
    end
  end
end

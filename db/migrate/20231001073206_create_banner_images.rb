class CreateBannerImages < ActiveRecord::Migration[7.0]
  def change
    create_table :banner_images do |t|
      t.jsonb :image_data
      t.text :image_credit

      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end

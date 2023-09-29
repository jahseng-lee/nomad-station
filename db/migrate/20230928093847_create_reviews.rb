class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, index: true
      t.references :location, null: false, index: true

      t.text :body

      t.integer :overall, null: false
      t.integer :fun, null: false
      t.integer :cost, null: false
      t.integer :internet, null: false
      t.integer :safety, null: false

      t.timestamps
    end
  end
end

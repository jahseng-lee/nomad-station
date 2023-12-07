class AddDescriptionToVisas < ActiveRecord::Migration[7.0]
  def change
    add_column :visas, :description, :text, null: false
  end
end

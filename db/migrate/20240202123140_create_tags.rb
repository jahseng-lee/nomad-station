class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.text :name, null: false

      t.timestamps
    end

    create_join_table :locations, :tags
  end
end

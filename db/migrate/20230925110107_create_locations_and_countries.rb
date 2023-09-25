class CreateLocationsAndCountries < ActiveRecord::Migration[7.0]
  def change
    create_table :countries do |t|
      t.text :name, null: false

      t.references :region, null: true, index: true
    end

    create_table :locations do |t|
      t.text :name, null: false
      t.text :name_utf8, null: false
      t.text :population

      t.references :country, null: false, index: true

      t.timestamps
    end
  end
end

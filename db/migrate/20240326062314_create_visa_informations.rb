class CreateVisaInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :visa_informations do |t|
      t.references :country, null: false
      t.references :citizenship, null: true, foreign_key: {
        to_table: :countries
      }
      t.text :body

      t.timestamps
    end

    add_index :visa_informations, [:country_id, :citizenship_id]
  end
end

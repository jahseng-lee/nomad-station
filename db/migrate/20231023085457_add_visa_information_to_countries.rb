class AddVisaInformationToCountries < ActiveRecord::Migration[7.0]
  def change
    # For freeform content on "Visas" page for locations
    add_column :countries, :visa_summary_information, :text

    # Table of visas for each country.
    create_table :visas do |t|
      t.references :country, null: false, index: true
      t.text :name, null: false

      t.timestamps
    end

    # Join table so that there can be many eligible countries
    # for each visa
    create_table :eligible_countries_for_visas do |t|
      t.references :country, null: false, index: true
      t.references :visa, null: false, index: true
    end
  end
end

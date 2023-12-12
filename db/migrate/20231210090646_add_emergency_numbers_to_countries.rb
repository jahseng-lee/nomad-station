class AddEmergencyNumbersToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :ambulance_number, :text
    add_column :countries, :police_number, :text
    add_column :countries, :fire_number, :text
  end
end

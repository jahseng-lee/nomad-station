class AddEmergencyNumbersToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :ambulance_number, :text
    add_column :locations, :police_number, :text
    add_column :locations, :fire_number, :text
  end
end

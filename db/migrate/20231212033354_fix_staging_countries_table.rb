class FixStagingCountriesTable < ActiveRecord::Migration[7.0]
  def change
    if Location.last.methods.include?(:ambulance_number)
      remove_column :locations, :ambulance_number, :text
      remove_column :locations, :police_number, :text
      remove_column :locations, :fire_number, :text

      add_column :countries, :ambulance_number, :text
      add_column :countries, :police_number, :text
      add_column :countries, :fire_number, :text
    end
  end
end

class AddIndexToLocationsPopulation < ActiveRecord::Migration[7.0]
  def change
    add_index :locations, :population
  end
end

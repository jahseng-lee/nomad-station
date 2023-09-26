class ChangePopulationToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :locations, :population, "integer USING ROUND(population::decimal)"
  end
end

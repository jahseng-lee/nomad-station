class RemoveVisas < ActiveRecord::Migration[7.0]
  def change
    drop_table :eligible_countries_for_visas
    drop_table :visas
  end
end

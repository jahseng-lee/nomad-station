class CreateCitizenships < ActiveRecord::Migration[7.0]
  def change
    create_table :citizenships do |t|
      t.references :user, null: false, index: true
      t.references :country, null: false

      t.timestamps
    end
  end
end

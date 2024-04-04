class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.text :issue_type, null: false
      t.text :body
      t.jsonb :additional_information # i.e. user's citizenship

      t.bigint :entity_id
      t.text :entity_type # i.e. "Location"
      t.boolean :resolved, null: false, default: false, index: true

      t.references :reporter,
        null: true,
        foreign_key: { to_table: :users },
        index: true

      t.timestamps
    end
  end
end

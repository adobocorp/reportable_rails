ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :name
    t.string :email
    t.timestamps
  end

  create_table :report_categories do |t|
    t.string :name, null: false
    t.text :description
    t.boolean :active, default: true
    t.timestamps
    t.index :name, unique: true
  end

  create_table :reports do |t|
    t.references :owner, null: false, foreign_key: { to_table: :users }
    t.references :report_category, foreign_key: true
    t.timestamps
  end

  create_table :hours_logs do |t|
    t.references :report, null: false, foreign_key: true
    t.decimal :hours, null: false, precision: 4, scale: 2
    t.date :date, null: false
    t.text :description, null: false
    t.timestamps
    t.index [:report_id, :date]
  end
end

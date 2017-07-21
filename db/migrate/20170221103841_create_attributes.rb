class CreateAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :attributes do |t|
      t.references :product, foreign_key: true, null: false
      t.integer :company_id, null: true
      t.integer :kind, default: 0
      t.json :data, default: {}
      t.decimal :base_price, default: 0
      t.integer :base_quantity, default: 1
      t.decimal :additional_price, default: 0
      t.integer :additional_quantity, default: 0
      t.timestamps
    end
  end
end

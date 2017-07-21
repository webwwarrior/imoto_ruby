class CreateOrderAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :order_attributes do |t|
      t.references :order, foreign_key: true, null: false
      t.integer :quantity, default: 1, null: false
      t.decimal :price, default: 0, null: false
      t.string :name, null: false
      t.json :data, default: {}, null: false

      t.timestamps
    end
  end
end

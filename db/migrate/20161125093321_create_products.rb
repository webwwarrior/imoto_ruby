class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.integer :status, default: 0
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end

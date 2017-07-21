class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0
      t.string :address
      t.string :second_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.decimal :listing_price
      t.float :square_footage
      t.float :number_of_beds
      t.float :number_of_baths
      t.float :number_of_half_beds
      t.text :listing_description
      t.text :additional_notes
      t.integer :coupon_id
      t.belongs_to :photographer, index: true
      t.belongs_to :customer, index: true

      t.timestamps
    end

    create_table :orders_products, id: false do |t|
      t.belongs_to :order, index: true
      t.belongs_to :product, index: true
      t.integer :quantity, default: 1
    end

    add_column :products, :price, :decimal
  end
end

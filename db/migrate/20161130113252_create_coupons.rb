class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :max_uses
      t.integer :max_uses_per_user
      t.date :start_date
      t.date :expiration_date
      t.decimal :minimum_purchase
      t.integer :discount_type, default: 0
      t.decimal :discount_amount
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

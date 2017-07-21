class AddColumnsToCoupons < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :track_coupon_usage, :integer, default: 0
    add_column :coupons, :company_id, :integer
    add_column :coupons, :order_id, :integer
  end
end

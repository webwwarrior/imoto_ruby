class RemoveCouponIdFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :coupon_id, :integer
  end
end

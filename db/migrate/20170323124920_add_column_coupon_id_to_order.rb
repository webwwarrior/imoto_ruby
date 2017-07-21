class AddColumnCouponIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :coupon_id, :integer
  end
end

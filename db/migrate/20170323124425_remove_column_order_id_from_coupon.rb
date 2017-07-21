class RemoveColumnOrderIdFromCoupon < ActiveRecord::Migration[5.0]
  def up
    remove_column :coupons, :order_id, :integer
  end

  def down
    add_column :coupons, :order_id, :integer
  end
end

class CreateJoinTableCouponCustomer < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons_customers, id: false do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :coupon, index: true
    end
  end
end

# == Schema Information
#
# Table name: orders_products
#
#  order_id   :integer
#  product_id :integer
#  quantity   :integer          default(1)
#
# Indexes
#
#  index_orders_products_on_order_id    (order_id)
#  index_orders_products_on_product_id  (product_id)
#

class OrdersProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
end

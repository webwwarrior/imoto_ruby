class AddColumnAttributeItemRefToOrderAttribute < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_attributes, :attribute_item, foreign_key: true
  end
end

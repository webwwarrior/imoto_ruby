class AddFieldProductIdToOrderAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :order_attributes, :product_id, :integer
  end
end

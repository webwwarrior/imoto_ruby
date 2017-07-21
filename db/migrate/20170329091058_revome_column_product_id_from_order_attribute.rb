class RevomeColumnProductIdFromOrderAttribute < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_attributes, :product_id, :integer
  end
end

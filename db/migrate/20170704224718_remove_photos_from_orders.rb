class RemovePhotosFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_attributes, :photos, :json
  end
end

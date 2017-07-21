class AddPhotosToOrderAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :order_attributes, :photos, :json
  end
end

class RemoveAdditionalQuantityFromAttributeItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :attribute_items, :additional_quantity, :integer, default: 0
  end
end

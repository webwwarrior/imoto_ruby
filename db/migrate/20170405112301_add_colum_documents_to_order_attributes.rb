class AddColumDocumentsToOrderAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :order_attributes, :document, :string
  end
end

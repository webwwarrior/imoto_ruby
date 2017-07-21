class DeletePriceFromProduct < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :price, :decimal
  end
end

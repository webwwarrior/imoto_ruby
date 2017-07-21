class AddColumnsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :step, :integer, default: 0, null: false
  end
end

class AddTravelCostsForOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :travel_costs, :decimal, default: 0, null: false
  end
end

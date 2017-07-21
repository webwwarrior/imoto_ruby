class AddColumnEstimatedTimeOrderAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :order_attributes, :estimated_time, :integer
  end
end

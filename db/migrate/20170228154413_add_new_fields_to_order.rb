class AddNewFieldsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :active_step, :integer
    add_column :orders, :current_step, :integer
  end
end

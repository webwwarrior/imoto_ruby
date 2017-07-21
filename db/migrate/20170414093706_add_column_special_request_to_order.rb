class AddColumnSpecialRequestToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :special_request, :text
  end
end

class AddColumnForFotographerAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :photographer_attributes, :rate, :decimal, defaul: 0.0
    add_column :photographer_attributes, :additional_rate, :decimal, default: 0.0
  end
end

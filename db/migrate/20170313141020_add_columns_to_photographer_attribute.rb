class AddColumnsToPhotographerAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :photographer_attributes, :default_time, :integer
    add_column :photographer_attributes, :extra_time, :integer
  end
end

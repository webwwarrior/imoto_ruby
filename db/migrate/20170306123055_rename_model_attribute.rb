class RenameModelAttribute < ActiveRecord::Migration[5.0]
  def up
    rename_table :attributes, :attribute_items
  end

  def down
    rename_table :attribute_items, :attributes
  end
end

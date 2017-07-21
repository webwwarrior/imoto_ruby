class AddFieldParentIdToAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :parent_id, :integer
  end
end

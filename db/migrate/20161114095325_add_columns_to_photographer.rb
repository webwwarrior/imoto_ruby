class AddColumnsToPhotographer < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :status, :integer, default: 0
  end
end

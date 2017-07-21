class AddNameToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :first_name, :string
    add_column :photographers, :last_name, :string
  end
end

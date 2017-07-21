class AddZipCodeForPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :zip_code, :string
  end
end

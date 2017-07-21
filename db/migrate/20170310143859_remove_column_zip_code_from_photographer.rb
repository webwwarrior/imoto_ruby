class RemoveColumnZipCodeFromPhotographer < ActiveRecord::Migration[5.0]
  def change
    remove_column :photographers, :zip_code, :string
  end
end

class AddColumnGoogleResourceIdToPhotographer < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :google_resource_id, :string
  end
end

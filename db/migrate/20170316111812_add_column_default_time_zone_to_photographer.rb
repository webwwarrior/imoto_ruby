class AddColumnDefaultTimeZoneToPhotographer < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :default_time_zone, :string
  end
end

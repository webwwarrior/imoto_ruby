class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :value, unique: true, null: false
      t.string :state_code, null: false
      t.string :state_name
      t.string :city
      t.string :time_zone

      t.timestamps
    end
  end
end

class CreateJoinTablePhotographerZipCode < ActiveRecord::Migration[5.0]
  def change
    create_table :photographers_zip_codes, id: false do |t|
      t.belongs_to :photographer, index: true
      t.belongs_to :zip_code, index: true
    end
  end
end

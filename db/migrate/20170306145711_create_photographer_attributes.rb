class CreatePhotographerAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :photographer_attributes do |t|
      t.references :photographer, foreign_key: true, null: false
      t.references :attribute_item, foreign_key: true, null: false

      t.timestamps
    end
  end
end

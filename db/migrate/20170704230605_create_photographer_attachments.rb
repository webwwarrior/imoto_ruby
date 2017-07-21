class CreatePhotographerAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :photographer_attachments do |t|
      t.references :photographer, foreign_key: true, null: false
      t.references :order_attribute, foreign_key: true, null: false
      t.string :attachment, null: false
      t.string :attachment_content_type, null: false

      t.timestamps
    end
  end
end

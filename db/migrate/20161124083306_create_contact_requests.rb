class CreateContactRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_requests do |t|
      t.string :sender_email
      t.text :body
      t.string :subject

      t.timestamps
    end
  end
end

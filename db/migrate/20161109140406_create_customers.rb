class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :mobile
      t.string :website
      t.string :avatar
      t.integer :company_id
      t.string :second_email
      t.string :third_email
      t.integer :role, default: 0

      t.timestamps
    end
  end
end

class CreateCreditCards < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_cards do |t|
      t.string :auth_code, null: false
      t.string :trans_id, null: false
      t.string :account_number, null: false
      t.string :account_type, null: false
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end

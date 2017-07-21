class AddFieldAuthorizationCodeToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :authorize_authorization_code, :string
    add_column :customers, :authorize_transaction_id, :string
  end
end

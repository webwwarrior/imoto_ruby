class AddColumnRemeberMeToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :remember_me, :boolean, default: false
  end
end

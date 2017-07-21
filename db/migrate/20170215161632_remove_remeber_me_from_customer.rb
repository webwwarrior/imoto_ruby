class RemoveRemeberMeFromCustomer < ActiveRecord::Migration[5.0]
  def change
    remove_column :customers, :remember_me, :boolean, default: false
  end
end

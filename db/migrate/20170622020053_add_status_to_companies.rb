class AddStatusToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :status, :string
  end
end

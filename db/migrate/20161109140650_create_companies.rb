class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :office_branch
      t.string :website
      t.string :logo
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end
end

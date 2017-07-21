class AddPhoneToPhotographer < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :phone, :string, limit: 50
  end
end

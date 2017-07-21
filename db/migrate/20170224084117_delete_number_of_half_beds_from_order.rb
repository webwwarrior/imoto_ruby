class DeleteNumberOfHalfBedsFromOrder < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :number_of_half_beds, :float
  end
end

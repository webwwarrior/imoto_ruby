class AddWorkdayToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :start_work_at, :datetime
    add_column :photographers, :end_work_at, :datetime
  end
end

class AddColumnsForPhotographers < ActiveRecord::Migration[5.0]
  def up
    change_column :photographers, :start_work_at, :time
    change_column :photographers, :end_work_at, :time
  end

  def down
    change_column :photographers, :start_work_at, :datetime
    change_column :photographers, :end_work_at, :datetime
  end
end

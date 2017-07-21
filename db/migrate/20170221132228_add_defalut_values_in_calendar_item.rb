class AddDefalutValuesInCalendarItem < ActiveRecord::Migration[5.0]
  def up
    change_column :calendar_items, :photographer_id, :integer, null: false
  end

  def down
    change_column :calendar_items, :photographer_id, :integer
  end
end

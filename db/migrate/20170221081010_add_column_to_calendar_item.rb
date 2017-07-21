class AddColumnToCalendarItem < ActiveRecord::Migration[5.0]
  def up
    add_column :calendar_items, :kind, :integer, default: 0
    add_column :calendar_items, :google_calendar_event_id, :string
    add_column :calendar_items, :description, :string
    add_column :calendar_items, :title, :string
    change_column :calendar_items, :unavailable_from, :datetime, null: false
    change_column :calendar_items, :unavailable_to, :datetime, null: false
  end

  def down
    remove_column :calendar_items, :kind, :integer, default: 0
    remove_column :calendar_items, :google_calendar_event_id, :string
    remove_column :calendar_items, :description, :string
    remove_column :calendar_items, :title, :string
    change_column :calendar_items, :unavailable_from, :datetime
    change_column :calendar_items, :unavailable_to, :datetime
  end
end

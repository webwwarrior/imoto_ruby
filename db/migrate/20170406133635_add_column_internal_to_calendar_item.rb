class AddColumnInternalToCalendarItem < ActiveRecord::Migration[5.0]
  def change
    add_column :calendar_items, :internal, :boolean, default: false
  end
end

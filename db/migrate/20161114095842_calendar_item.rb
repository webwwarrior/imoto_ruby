class CalendarItem < ActiveRecord::Migration[5.0]
  def change
    create_table :calendar_items do |t|
      t.belongs_to :photographer, index: true
      t.datetime :unavailable_from
      t.datetime :unavailable_to

      t.timestamps
    end
  end
end

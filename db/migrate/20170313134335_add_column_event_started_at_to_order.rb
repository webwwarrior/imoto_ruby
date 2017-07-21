class AddColumnEventStartedAtToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :event_started_at, :datetime
  end
end

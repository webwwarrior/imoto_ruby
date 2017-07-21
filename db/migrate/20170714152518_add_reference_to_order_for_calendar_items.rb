class AddReferenceToOrderForCalendarItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :calendar_items, :order, foreign_key: { on_delete: :cascade }
  end
end

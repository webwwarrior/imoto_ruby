# == Schema Information
#
# Table name: calendar_items
#
#  id                       :integer          not null, primary key
#  photographer_id          :integer          not null
#  unavailable_from         :datetime         not null
#  unavailable_to           :datetime         not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  kind                     :integer          default("scheduled")
#  google_calendar_event_id :string
#  description              :string
#  title                    :string
#  internal                 :boolean          default(FALSE)
#  order_id                 :integer
#
# Indexes
#
#  index_calendar_items_on_order_id         (order_id)
#  index_calendar_items_on_photographer_id  (photographer_id)
#
# Foreign Keys
#
#  fk_rails_0f7cff9dd7  (order_id => orders.id) ON DELETE => cascade
#

class CalendarItem < ApplicationRecord
  before_validation :set_default

  belongs_to :photographer
  belongs_to :order, optional: true

  enum kind: [:scheduled, :unavailable]

  validates_presence_of :unavailable_from, :unavailable_to
  validates_uniqueness_of :google_calendar_event_id, allow_blank: true, scope: :photographer_id
  validates_inclusion_of :kind, in: CalendarItem.kinds.keys

  scope :by_range, ->(from, to) do
    where(
      '"calendar_items"."unavailable_from" >= :from AND "calendar_items"."unavailable_to" <= :to', from: from, to: to
    )
  end

  def set_default
    self.kind = :scheduled if kind.blank?
    self.internal = false if internal.blank?
  end
end

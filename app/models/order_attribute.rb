# == Schema Information
#
# Table name: order_attributes
#
#  id                :integer          not null, primary key
#  order_id          :integer          not null
#  quantity          :integer          default(1), not null
#  price             :decimal(, )      default(0.0), not null
#  name              :string           not null
#  data              :json             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  estimated_time    :integer
#  attribute_item_id :integer
#  document          :string
#
# Indexes
#
#  index_order_attributes_on_attribute_item_id  (attribute_item_id)
#  index_order_attributes_on_order_id           (order_id)
#
# Foreign Keys
#
#  fk_rails_2f76de33a7  (order_id => orders.id)
#  fk_rails_8f8cbfb8de  (attribute_item_id => attribute_items.id)
#

class OrderAttribute < ApplicationRecord
  mount_uploader :document, DocumentsUploader

  belongs_to :order
  belongs_to :attribute_item, optional: true # this association needs only while create new order by customer

  has_many :photographer_attachments, dependent: :destroy

  validates :name,     presence: true
  validates :price,    presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validate  :document_type_format

  scope :for_product, ->(product_id) { joins(:attribute_item).where(attribute_items: { product_id: product_id }) }
  scope :with_uncompleted_orders, -> { joins(:order).where.not(orders: { status: :completed }) }
  scope :parent_item_ids, -> do
    joins(:attribute_item).pluck('COALESCE(attribute_items.parent_id, attribute_items.id)').uniq
  end
  scope :by_photographer_day, ->(photographer, day) do
    where(order_id: photographer.orders.by_day(day), name: 'Photo Shoot')
  end

  def formatted_data
    return data.map { |_key, value| value }.to_json if attribute_item.input?
    return data.to_json unless attribute_item.single_select? || attribute_item.dependent_select?
    data.map { |key, value| { key: key, value: value } }.to_json
  end

  private

  def document_type_format
    return if document.blank? || attribute_item.data['extensions'].include?(document.file.extension)
    raise GraphQL::ExecutionError.new("You are not allowed to upload files in #{document.file.extension} format")
  end
end

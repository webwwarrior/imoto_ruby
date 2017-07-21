# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  sku         :string
#  status      :integer          default("disabled")
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image       :string
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#

class Product < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :category, optional: true
  has_many   :orders_products
  has_many   :orders, through: :orders_products
  has_many   :attribute_items, dependent: :destroy, inverse_of: :product

  accepts_nested_attributes_for :attribute_items, allow_destroy: true

  enum status: [:disabled, :enabled]

  validates :name, presence: true

  attr_accessor :selected_order_attributes

  scope :with_attribute_items, ->(attr_ids) do
    joins(:attribute_items).where(attribute_items: { id: attr_ids }).distinct
  end
end

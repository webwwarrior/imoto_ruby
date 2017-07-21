# == Schema Information
#
# Table name: attribute_items
#
#  id               :integer          not null, primary key
#  product_id       :integer          not null
#  company_id       :integer
#  kind             :integer          default("switch")
#  data             :json
#  base_price       :decimal(, )      default(0.0)
#  base_quantity    :integer          default(1)
#  additional_price :decimal(, )      default(0.0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer
#
# Indexes
#
#  index_attribute_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_bd0d4debc1  (product_id => products.id)
#

class AttributeItem < ApplicationRecord
  KINDS_MAPPER = {
    'switch'           => %w(label description),
    'dependent_select' => %w(quantity_range main_select_label subselect_labels),
    'input'            => %w(unit note kind),
    'tags'             => %w(placeholder),
    'upload'           => %w(extensions)
  }.freeze

  belongs_to :company, optional: true
  belongs_to :product
  has_many   :order_attributes # this association needs only while create new order by customer
  has_many   :photographer_attributes, dependent: :destroy

  enum kind: [:switch, :single_select, :order_details, :input, :dependent_select, :hidden, :tags, :upload]

  validates :base_price,          presence: true, numericality: { greater_than: 0 }
  validates :base_quantity,       presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :additional_price,    presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :validate_data
  validate :attribute_item_options

  with_options unless: :tags? do |attr_item|
    attr_item.validates :base_price, presence: true, numericality: { greater_than: 0 }
  end

  before_validation :change_data_format

  scope :customized, ->(company_id) { where(company_id: company_id) }
  scope :basic,      ->(company_id) { where(company_id: nil).where.not(id: customized(company_id).pluck(:parent_id)) }

  def total_price(quantity)
    (quantity.to_i - base_quantity) * additional_price + base_price
  end

  def name
    switch? ? data['label'] : product.name
  end

  def kind_name
    kind.tr('_', ' ').camelize
  end

  def extended_name
    switch? ? "#{product.name} (#{name})" : name
  end

  def customized_attribute(photographer_id)
    photographer_attributes.find_by(photographer_id: photographer_id)
  end

  def formatted_data
    return data.map { |key, price| { label: "#{key} Photos", value: key, price: "#{price.to_f}" } }.to_json if single_select?
    return formatted_dependent_select if dependent_select?
    data.to_json
  end

  private

  def change_data_format
    self.data = Hash[data['quantity'].zip(data['price'])] if single_select? && data.include?('quantity')
  end

  def validate_data
    add_errors(KINDS_MAPPER[kind]) if %w(hidden order_details single_select).exclude?(kind)
  end

  def attribute_item_options
    return unless single_select? && data.keys.any? { |v| v.to_i < base_quantity.to_i }
    errors.add :quantity, 'can`t be less than base quantity'
  end

  def add_errors(keys)
    keys.each { |key| errors.add(key, 'can`t be blank') if data[key].blank? }
  end

  # rubocop:disable all
  def formatted_dependent_select
    main_select = (data['quantity_range'].first..data['quantity_range'].last).map do |quantity|
      { label: "#{quantity} #{data['main_select_label'].pluralize(quantity.to_i)}",
        value: quantity.to_i, price: total_price(quantity) }
    end
    dependent_select = data['subselect_labels'].map { |item| { label: item, value: item } }

    { main_select: main_select, dependent_select: dependent_select }.to_json
  end
  # rubocop:enable all
end

# == Schema Information
#
# Table name: orders
#
#  id                  :integer          not null, primary key
#  status              :integer          default("pending")
#  address             :string
#  second_address      :string
#  city                :string
#  state               :string
#  zip_code            :string
#  listing_price       :decimal(, )
#  square_footage      :float
#  number_of_beds      :float
#  number_of_baths     :float
#  listing_description :text
#  additional_notes    :text
#  photographer_id     :integer
#  customer_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  step                :integer          default("initial"), not null
#  active_step         :integer
#  current_step        :integer
#  event_started_at    :datetime
#  coupon_id           :integer
#  travel_costs        :decimal(, )      default(0.0), not null
#  special_request     :text
#
# Indexes
#
#  index_orders_on_customer_id      (customer_id)
#  index_orders_on_photographer_id  (photographer_id)
#

class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :photographer, optional: true
  belongs_to :coupon, optional: true
  has_many   :orders_products
  has_many   :products, through: :orders_products
  has_many   :order_attributes, dependent: :destroy
  has_one    :calendar_item

  before_save :update_photographer_calendar, if: :photographer

  enum status: %i(pending in_progress completed)
  enum step:   %i(initial listing listing_confirmation products_selection photographer_selection billing confirmed)

  scope :by_id_and_customer_name, ->(id, name) do
    joins('LEFT JOIN customers ON customers.id = orders.customer_id')
      .select('orders.*, customers.full_name')
      .where('full_name ILIKE ? OR orders.id = ?', name.blank? ? nil : "%#{name}%", id.blank? ? nil : id)
  end

  scope :by_day, ->(date) do
    where('date("orders"."event_started_at") = :date', date: date)
  end

  scope :total_price, -> do
    joins(:order_attributes).sum('"order_attributes"."price" * "order_attributes"."quantity"')
  end

  with_options if: :listing? do |order|
    order.validates :state,    presence: true
    order.validates :zip_code, presence: true
  end

  with_options if: :listing_confirmation? do |order|
    order.validates :address,         presence: true
    order.validates :city,            presence: true
    order.validates :listing_price,   presence: true
    order.validates :square_footage,  presence: true
    order.validates :number_of_beds,  presence: true
    order.validates :number_of_baths, presence: true
  end

  with_options if: :photographer_selection? do |order|
    order.validates :photographer_id,  presence: true
    order.validates :event_started_at, presence: true
  end

  def full_address
    "#{city.upcase}, #{zip_code}, #{state}. #{address}"
  end

  def execution_time
    event_started_at + order_attributes.sum(&:estimated_time).minutes
  end

  def total_price
    @total_price ||= order_attributes.sum(:price)
  end

  def price_with_discount
    return total_price unless coupon.present?
    amount = coupon.discount_amount
    coupon.flat_amount? ? total_price - amount : total_price - (total_price * amount / 100)
  end

  def attribute_ids_with_qauntity
    quantities = order_attributes.pluck(:quantity)
    attr_ids   = order_attributes.parent_item_ids
    attr_ids.zip(quantities)
  end

  private

  def update_photographer_calendar
    estimated_time = order_attributes.map { |attribute| attribute.estimated_time || 0 }.sum
    finish_time = event_started_at + estimated_time
    update_calendar_items(finish_time)
  end

  def update_calendar_items(finish_time)
    if calendar_item
      calendar_item.update description: listing_description, kind: :scheduled, photographer: photographer,
                           title: full_address, unavailable_from: event_started_at, unavailable_to: finish_time
    else
      photographer.calendar_items.create description: listing_description, kind: :scheduled, title: full_address,
                                         order_id: id, unavailable_from: event_started_at, unavailable_to: finish_time
    end
  end
end

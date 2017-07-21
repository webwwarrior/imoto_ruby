require 'administrate/base_dashboard'

class CouponDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    company:             Field::BelongsTo.with_options(searchable: false),
    status:              Field::Select.with_options(collection: Coupon.statuses.keys, searchable: false),
    name:                Field::String,
    code:                Field::String,
    max_uses_per_user:   Field::Number,
    max_uses:            Field::Number,
    start_date:          Field::Date,
    expiration_date:     Field::Date,
    minimum_purchase:    Field::Decimal,
    discount_type:       Field::Select.with_options(collection: Coupon.discount_types.keys, searchable: false),
    track_coupon_usage:  Field::Number,
    discount_amount:     Field::Decimal
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :company,
    :status,
    :name,
    :code,
    :max_uses_per_user,
    :max_uses,
    :minimum_purchase,
    :discount_type,
    :track_coupon_usage,
    :start_date,
    :expiration_date,
    :discount_amount
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :company,
    :status,
    :name,
    :code,
    :max_uses_per_user,
    :max_uses,
    :minimum_purchase,
    :discount_type,
    :track_coupon_usage,
    :start_date,
    :expiration_date,
    :discount_amount
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form ( `edit`) pages.
  FORM_ATTRIBUTES = [
    :company,
    :status,
    :name,
    :code,
    :discount_type,
    :start_date,
    :expiration_date,
    :minimum_purchase,
    :discount_amount,
    :max_uses_per_user,
    :max_uses
  ].freeze
end

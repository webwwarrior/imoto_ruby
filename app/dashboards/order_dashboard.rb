require 'administrate/base_dashboard'

class OrderDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:                  Field::Number,
    customer:            Field::BelongsTo,
    coupon:              Field::BelongsTo.with_options(searchable: false),
    status:              Field::String.with_options(searchable: false),
    address:             Field::String.with_options(searchable: false),
    city:                Field::String.with_options(searchable: false),
    state:               Field::String.with_options(searchable: false),
    zip_code:            Field::String.with_options(searchable: false),
    step:                Field::String.with_options(searchable: false),
    updated_at:          Field::DateTime.with_options(searchable: false),
    listing_price:       Field::Decimal.with_options(searchable: false),
    second_address:      Field::String.with_options(searchable: false),
    square_footage:      Field::Decimal.with_options(searchable: false),
    number_of_beds:      Field::Decimal.with_options(searchable: false),
    number_of_baths:     Field::Decimal.with_options(searchable: false),
    event_started_at:    Field::DateTime.with_options(searchable: false),
    additional_notes:    Field::Text.with_options(searchable: false),
    listing_description: Field::Text.with_options(searchable: false)
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :customer,
    :status,
    :updated_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :status,
    :customer,
    :coupon,
    :address,
    :second_address,
    :city,
    :state,
    :zip_code,
    :listing_price,
    :square_footage,
    :number_of_beds,
    :listing_description,
    :additional_notes,
    :step,
    :event_started_at,
    :updated_at
  ].freeze
end

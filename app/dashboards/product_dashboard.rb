require 'administrate/base_dashboard'

class ProductDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    category:    Field::BelongsTo.with_options(searchable: false),
    name:        Field::String,
    description: Field::String,
    sku:         Field::String,
    status:      Field::String.with_options(searchable: false),
    image:       Field::Image
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :category,
    :name,
    :description,
    :sku,
    :status,
    :image
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :category,
    :name,
    :description,
    :sku,
    :status,
    :image
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form ( `edit`) pages.
  FORM_ATTRIBUTES = [
    :category,
    :name,
    :description,
    :sku,
    :status,
    :image
  ].freeze
end

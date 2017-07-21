require 'administrate/base_dashboard'

class CompanyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name:          Field::String,
    office_branch: Field::String,
    website:       Field::String,
    logo:          Field::Image,
    city:          Field::String,
    state:         Field::String,
    zip_code:      Field::String,
    status:        Field::Select.with_options(collection: %w(active pending)),
    coupons:       Field::HasMany.with_options(searchable: false)
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :office_branch,
    :website,
    :logo,
    :city,
    :state,
    :zip_code,
    :status,
    :coupons
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :office_branch,
    :website,
    :logo,
    :city,
    :state,
    :zip_code,
    :status,
    :coupons
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form ( `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :office_branch,
    :website,
    :logo,
    :city,
    :state,
    :zip_code,
    :status,
    :coupons
  ].freeze
end

require 'administrate/base_dashboard'

class CustomerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    status:       Field::Select.with_options(searchable: false, collection: Customer.statuses.keys),
    company:      Field::BelongsTo.with_options(searchable: false),
    full_name:    Field::String,
    mobile:       Field::String,
    website:      Field::String,
    avatar:       Field::String.with_options(searchable: false),
    second_email: Field::String,
    third_email:  Field::String,
    role:         Field::String.with_options(searchable: false),
    email:        Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :company,
    :full_name,
    :mobile,
    :role,
    :email,
    :status
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :company,
    :full_name,
    :email,
    :second_email,
    :third_email,
    :mobile,
    :website,
    :role,
    :status
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form ( `edit`) pages.
  FORM_ATTRIBUTES = [
    :company,
    :full_name,
    :email,
    :second_email,
    :third_email,
    :mobile,
    :website,
    :role,
    :status
  ].freeze
end

require 'administrate/base_dashboard'

class PhotographerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    first_name:            Field::String,
    last_name:             Field::String,
    email:                 Field::String,
    password:              Field::Password,
    password_confirmation: Field::Password,
    start_work_at:         Field::Time,
    end_work_at:           Field::Time,
    default_time_zone:     Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :start_work_at,
    :end_work_at,
    :default_time_zone
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :start_work_at,
    :end_work_at,
    :default_time_zone
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form ( `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation,
    :start_work_at,
    :end_work_at,
    :password,
    :password_confirmation
  ].freeze
end

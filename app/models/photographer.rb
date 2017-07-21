# == Schema Information
#
# Table name: photographers
#
#  id                     :integer          not null, primary key
#  avatar                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string
#  last_name              :string
#  status                 :integer          default("active")
#  google_access_token    :string
#  google_refresh_token   :string
#  provider               :string
#  uid                    :string
#  google_expires_at      :integer
#  start_work_at          :time
#  end_work_at            :time
#  default_time_zone      :string
#  google_resource_id     :string
#  phone                  :string(50)
#
# Indexes
#
#  index_photographers_on_email                 (email) UNIQUE
#  index_photographers_on_reset_password_token  (reset_password_token) UNIQUE
#

class Photographer < ApplicationRecord
  include Devise::Models::Recoverable

  attr_accessor :available_ranges

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  mount_uploader :avatar, AvatarUploader

  enum status: [:active, :suspended]

  has_many :orders
  has_many :calendar_items, dependent: :destroy
  has_many :photographer_attributes, dependent: :destroy
  has_many :attachments, class_name: 'PhotographerAttachment'
  has_and_belongs_to_many :zip_codes

  validates :phone, format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/, allow_blank: true }

  scope :with_zipcode, ->(code) { joins(:zip_codes).where(zip_codes: { value: code }) }
  scope :competent,    ->(ids) do
    joins(:photographer_attributes).where(photographer_attributes: { attribute_item_id: ids })
                                   .group("photographers.id HAVING COUNT(DISTINCT attribute_item_id) = #{ids.length}")
  end
  scope :with_city_and_state, -> { joins(:zip_codes).select('photographers.*, zip_codes.city, zip_codes.state_name') }

  scope :with_name, ->(first_name, last_name) do
    where('first_name ILIKE ? AND last_name ILIKE ?', "%#{first_name}%", "%#{last_name}")
  end

  scope :with_location, ->(search, filed) do
    where("#{filed} ILIKE ?", "%#{search}%").distinct(:id).order(:id)
  end

  def full_name
    first_name && last_name ? "#{first_name} #{last_name}" : first_name || last_name
  end

  def total_orders_count
    orders.count
  end

  def uploaded_orders_count
    orders.completed.count
  end

  def google_token
    google_token_valid? ? google_access_token : GoogleClient.new(self).refresh_token!
  end

  def google_token_valid?
    google_expires_at.present? && google_expires_at > Time.current.to_i
  end

  accepts_nested_attributes_for :photographer_attributes, allow_destroy: true
end

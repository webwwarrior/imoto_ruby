# == Schema Information
#
# Table name: customers
#
#  id                           :integer          not null, primary key
#  full_name                    :string
#  mobile                       :string
#  website                      :string
#  avatar                       :string
#  company_id                   :integer
#  second_email                 :string
#  third_email                  :string
#  role                         :integer          default("homeowner")
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  email                        :string           default(""), not null
#  encrypted_password           :string           default(""), not null
#  reset_password_token         :string
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :inet
#  last_sign_in_ip              :inet
#  status                       :integer          default("enabled")
#  authorize_authorization_code :string
#  authorize_transaction_id     :string
#
# Indexes
#
#  index_customers_on_email                 (email) UNIQUE
#  index_customers_on_reset_password_token  (reset_password_token) UNIQUE
#

class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  enum role:   [:homeowner, :agent]
  enum status: [:enabled, :disabled]

  belongs_to :company, optional: true
  has_many   :orders
  has_many   :credit_cards, dependent: :destroy
  has_and_belongs_to_many :coupons

  def orders_not_completed
    orders.where.not(status: :completed)
  end
end

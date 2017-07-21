# == Schema Information
#
# Table name: coupons
#
#  id                 :integer          not null, primary key
#  name               :string
#  code               :string
#  max_uses           :integer
#  max_uses_per_user  :integer
#  start_date         :date
#  expiration_date    :date
#  minimum_purchase   :decimal(, )
#  discount_type      :integer          default("percentage")
#  discount_amount    :decimal(, )
#  status             :integer          default("enabled")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  track_coupon_usage :integer          default(0)
#  company_id         :integer
#

class Coupon < ApplicationRecord
  has_many   :orders
  belongs_to :company
  has_and_belongs_to_many :customers

  enum status:        [:enabled, :disabled]
  enum discount_type: [:percentage, :flat_amount]

  validates :name,                presence: true
  validates :code,                presence: true
  validates :discount_amount,     presence: true, numericality: { greater_than: 0 }
  validates :minimum_purchase,    numericality: { greater_than: 0 }
  validates :max_uses,            numericality: { greater_than_or_equal_to: 1 }
  validates :max_uses_per_user,   numericality: { greater_than_or_equal_to: 1 }

  def active?
    (start_date <= Date.current && Date.current <= expiration_date) && track_coupon_usage < max_uses
  end
end

# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  name          :string
#  office_branch :string
#  website       :string
#  logo          :string
#  city          :string
#  state         :string
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :string
#

class Company < ApplicationRecord
  mount_uploader :logo, LogoUploader

  has_many :customers
  has_many :coupons, dependent: :destroy
  has_many :attribute_items, dependent: :destroy

  validates :name, presence: true
  validates :office_branch, uniqueness: { scope: :name }

  scope :active, -> { where(status: 'active') }

  # Status can be the following
  #  - pending: the default status
  #  - active

  before_create :init_status

  private

  def init_status
    self.status = 'pending' unless status.present?
  end
end

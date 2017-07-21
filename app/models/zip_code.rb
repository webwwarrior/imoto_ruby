# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer          not null, primary key
#  value      :string           not null
#  state_code :string           not null
#  state_name :string
#  city       :string
#  time_zone  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ZipCode < ApplicationRecord
  has_and_belongs_to_many :photographers

  scope :search, ->(term) { where('value ILIKE(:term)', term: "%#{term}%") }
end

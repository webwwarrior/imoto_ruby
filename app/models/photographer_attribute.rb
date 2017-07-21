# == Schema Information
#
# Table name: photographer_attributes
#
#  id                :integer          not null, primary key
#  photographer_id   :integer          not null
#  attribute_item_id :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  default_time      :integer
#  extra_time        :integer
#  rate              :decimal(, )
#  additional_rate   :decimal(, )      default(0.0)
#
# Indexes
#
#  index_photographer_attributes_on_attribute_item_id  (attribute_item_id)
#  index_photographer_attributes_on_photographer_id    (photographer_id)
#
# Foreign Keys
#
#  fk_rails_19139c888c  (photographer_id => photographers.id)
#  fk_rails_c322c14386  (attribute_item_id => attribute_items.id)
#

class PhotographerAttribute < ApplicationRecord
  belongs_to :photographer
  belongs_to :attribute_item

  validates :default_time, presence: true, numericality: { greater_than_or_equal_to: 1 }
end

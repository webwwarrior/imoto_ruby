# == Schema Information
#
# Table name: photographer_attachments
#
#  id                      :integer          not null, primary key
#  photographer_id         :integer          not null
#  order_attribute_id      :integer          not null
#  attachment              :string           not null
#  attachment_content_type :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_photographer_attachments_on_order_attribute_id  (order_attribute_id)
#  index_photographer_attachments_on_photographer_id     (photographer_id)
#
# Foreign Keys
#
#  fk_rails_63c927f19d  (order_attribute_id => order_attributes.id)
#  fk_rails_b60968036b  (photographer_id => photographers.id)
#

class PhotographerAttachment < ApplicationRecord
  belongs_to :photographer
  belongs_to :order_attribute

  mount_uploader :attachment, AttachmentUploader

  before_validation :set_attachment_type

  validates :photographer, :order_attribute, :attachment, presence: true
  validate :validate_attribute_owner, if: ->(record) do
    record.photographer_id != record.order_attribute.order.photographer_id
  end

  scope :count_by_photographer_day, ->(photographer, day) do
    where(order_attribute_id: OrderAttribute.by_photographer_day(photographer, day)).count
  end

  # eWarp attributes
  def bucket
    order_attribute_id
  end

  def key
    attachment.url
  end

  def name
    File.basename attachment.path
  end

  def md5
    open(attachment.url) { |f| Digest::MD5.hexdigest f.read }
  end

  private

  def set_attachment_type
    self.attachment_content_type = attachment.content_type && attachment.content_type[%r{^[^/]+}] || 'application'
  end

  def validate_attribute_owner
    errors.add(:base, 'You are not owner of current attribute')
  end
end

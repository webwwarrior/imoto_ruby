# == Schema Information
#
# Table name: contact_requests
#
#  id           :integer          not null, primary key
#  sender_email :string
#  body         :text
#  subject      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ContactRequest < ApplicationRecord
  validates :sender_email, presence: true
  validates :subject,      presence: true
  validates :body,         presence: true
end

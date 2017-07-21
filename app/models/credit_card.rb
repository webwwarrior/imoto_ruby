# == Schema Information
#
# Table name: credit_cards
#
#  id             :integer          not null, primary key
#  auth_code      :string           not null
#  trans_id       :string           not null
#  account_number :string           not null
#  account_type   :string           not null
#  customer_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_credit_cards_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_f2ebe1297e  (customer_id => customers.id)
#

class CreditCard < ApplicationRecord
  belongs_to :customer

  validates :auth_code,      presence: true
  validates :trans_id,       presence: true
  validates :account_number, presence: true
  validates :account_type,   presence: true
end

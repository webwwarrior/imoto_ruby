require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it { is_expected.to belong_to :customer }
  it { is_expected.to validate_presence_of :auth_code }
  it { is_expected.to validate_presence_of :trans_id }
  it { is_expected.to validate_presence_of :account_number }
  it { is_expected.to validate_presence_of :account_type }
end

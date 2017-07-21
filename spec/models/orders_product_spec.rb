require 'rails_helper'

describe OrdersProduct do
  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }
end

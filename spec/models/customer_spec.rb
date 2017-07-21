require 'rails_helper'

describe Customer do
  it { is_expected.to belong_to(:company) }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:credit_cards).dependent(:destroy) }
  it { is_expected.to have_and_belong_to_many :coupons }

  it { is_expected.to define_enum_for(:role).with([:homeowner, :agent]) }
  it { is_expected.to define_enum_for(:status).with([:enabled, :disabled]) }

  describe '#orders_not_completed' do
    let!(:customer) { create :customer }
    let!(:order)  { create :order, customer: customer, status: :completed }
    let!(:order1) { create :order, customer: customer, status: :completed }

    context 'return orders' do
      let!(:order2) { create :order, customer: customer, status: :in_progress }

      it { expect(customer.orders_not_completed).to contain_exactly order2 }
    end

    it { expect(customer.orders_not_completed).to be_empty }
  end
end

require 'rails_helper'

describe Resolvers::Customer::ApplyDiscountCode do
  subject(:resolver) { described_class.new }

  let!(:customer) { create :customer }
  let(:context)   { { current_user: customer } }
  let!(:order)    { create :order, id: 1, coupon_id: nil }
  let!(:coupon)   { create :coupon, code: '1234' }
  let(:object)    { double :object }
  let!(:inputs)   { { 'order_id' => 1, 'code' => '1234' } }

  context 'successful' do
    before do
      allow_any_instance_of(described_class).to receive(:valid_coupon_count?) { true }
      allow_any_instance_of(coupon.class).to receive(:active?) { true }
    end

    it { expect(resolver.call(object, inputs, context)[:order].coupon_id).to eq coupon.id }
  end

  context 'failure (customer is not authorized)' do
    let!(:customer) { nil }

    it { expect { resolver.call(object, inputs, context) }.to raise_error 'You are not authorized' }
  end

  context 'failure (invalid coupon code)' do
    specify do
      expect { resolver.call(object, inputs.merge('code' => '0000'), context) }
        .to raise_error 'Can not find coupon with discount code 0000'
    end
  end

  context 'failure (code have been applied already)' do
    let!(:order2)  { create :order, id: 2, coupon: coupon }
    let!(:inputs) { { 'order_id' => 2, 'code' => '1234' } }

    specify do
      expect { resolver.call(object, inputs, context) }
        .to raise_error 'You have already applied discount'
    end
  end

  context 'failure (valid coupon count)' do
    before { allow_any_instance_of(described_class).to receive(:valid_coupon_count?) { false } }

    specify do
      expect { resolver.call(object, inputs, context) }
        .to raise_error 'You have reached your limit already'
    end
  end

  context 'failure (coupon has been expired already)' do
    before do
      allow_any_instance_of(described_class).to receive(:valid_coupon_count?) { true }
      allow_any_instance_of(coupon.class).to receive(:active?) { false }
    end

    specify do
      expect { resolver.call(object, inputs, context) }
        .to raise_error 'Your coupon has been expired already'
    end
  end
end

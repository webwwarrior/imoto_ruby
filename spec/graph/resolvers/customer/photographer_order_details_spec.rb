require 'rails_helper'

describe Resolvers::Customer::PhotographerOrderDetails do
  subject(:resolver)  { described_class.new }
  let!(:customer)     { create :customer }
  let(:context)       { { current_user: customer } }
  let(:object)        { double :object }
  let!(:order)        { create :order, customer: customer, id: 1, photographer_id: nil }
  let!(:photographer) { create :photographer }

  let!(:inputs) do
    { 'order_id'        => '1',
      'photographer_id' => '1',
      'time_range'      => '2016-10-21T10:25:00+00:00..2016-10-21T14:00:00+00:00' }
  end

  context 'successful' do
    before do
      allow_any_instance_of(described_class).to receive(:setup_estimated_time_for_attributes) { true }
    end

    specify do
      resolver.call(object, inputs, context)

      Order.last.tap do |order|
        expect(order.id).to               eq 1
        expect(order.photographer_id).to  eq 1
        expect(order.event_started_at).to eq DateTime.new(2016, 10, 21, 10, 25, 00)
      end
    end
  end

  context 'failure (customer is not authorized)' do
    let!(:order)  { create :order, customer: customer, id: 2 }
    let(:context) { { helpers: { current_user: nil } } }

    it { expect { resolver.call(object, inputs.merge(id: 2), context) }.to raise_error 'You are not authorized' }
  end

  context 'failure (photographer_id cannot be blank)' do
    specify do
      expect { resolver.call(object, inputs.merge('photographer_id' => ''), context) }
        .to raise_error "Invalid input for Order: Photographer can't be blank"
    end
  end
end

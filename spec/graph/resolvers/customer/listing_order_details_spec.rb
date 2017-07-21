require 'rails_helper'

describe Resolvers::Customer::ListingOrderDetails do
  subject(:resolver) { described_class.new }
  let!(:customer)    { create :customer }
  let(:context)      { { current_user: customer } }
  let(:object)       { double :object }
  let!(:order)       { create :order, customer: customer, id: 1 }

  let!(:inputs) do
    { 'id'              => '1',
      'address'         => 'Shevchenko avenue',
      'city'            => 'Lviv',
      'state'           => 'LV',
      'zip_code'        => '123Q',
      'listing_price'   => '234',
      'square_footage'  => '100',
      'number_of_beds'  => '2',
      'number_of_baths' => '1' }
  end

  context 'successful' do
    specify do
      resolver.call(object, inputs, context)

      Order.last.tap do |order|
        expect(order.id).to              eq 1
        expect(order.address).to         eq 'Shevchenko avenue'
        expect(order.city).to            eq 'Lviv'
        expect(order.state).to           eq 'LV'
        expect(order.zip_code).to        eq '123Q'
        expect(order.listing_price).to   eq 234
        expect(order.square_footage).to  eq 100
        expect(order.number_of_beds).to  eq 2
        expect(order.number_of_baths).to eq 1
      end
    end
  end

  context 'failure (customer is not authorized)' do
    let!(:order)  { create :order, customer: customer, id: 2 }
    let(:context) { { helpers: { current_user: nil } } }

    it { expect { resolver.call(object, inputs.merge(id: 2), context) }.to raise_error 'You are not authorized' }
  end

  context 'failure (city cannot be blank)' do
    specify do
      expect { resolver.call(object, inputs.merge(city: ''), context) }
        .to raise_error "Invalid input for Order: City can't be blank"
    end
  end
end

require 'rails_helper'

describe Resolvers::Customer::CreateOrder do
  subject(:resolver)  { described_class.new }

  let!(:customer)     { create :customer }
  let!(:photographer) { create :photographer,  id: 1 }
  let!(:product1)     { create :product, id: 1 }
  let!(:product2)     { create :product, id: 2 }
  let(:context)       { { current_user: customer } }
  let(:object)        { double :object }

  let!(:inputs) do
    { 'address' => 'Shevchenko avenue',
      'city' => 'Lviv',
      'state' => 'LV',
      'zip_code' => '123Q',
      'photographer_id' => 1,
      'products' => [
        { 'id' => 1, 'quantity'  => 1 },
        { 'id' => 2, 'quantity'  => 2 }
      ] }
  end

  context 'successful' do
    it { expect { resolver.call(object, inputs, context) }.to change(Order, :count).by(1) }
    it { expect { resolver.call(object, inputs, context) }.to change(OrdersProduct, :count).by(2) }
  end

  context 'failure (customer is not authorized)' do
    let!(:customer) { nil }

    it { expect { resolver.call(object, inputs, context) }.to raise_error 'You are not authorized' }
  end
end

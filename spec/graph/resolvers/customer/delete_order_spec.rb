require 'rails_helper'

describe Resolvers::Customer::DeleteOrder do
  subject(:resolver) { described_class.new }

  let!(:customer)    { create :customer }
  let!(:order)       { create :order, customer: customer }
  let(:context)      { { current_user: customer } }
  let(:object)       { double :object }
  let!(:order_attr1) { create :order_attribute, order: order }
  let!(:order_attr2) { create :order_attribute, order: order }

  let!(:inputs) { { 'id' => order.id } }

  context 'successful' do
    it { expect { resolver.call(object, inputs, context) }.to change(Order, :count).by(-1) }
    it { expect { resolver.call(object, inputs, context) }.to change(OrderAttribute, :count).by(-2) }
  end

  context 'failure (customer is not authorized)' do
    let(:context) { { current_user: nil } }

    it { expect { resolver.call(object, inputs, context) }.to raise_error 'You are not authorized' }
  end
end

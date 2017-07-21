require 'rails_helper'

describe Resolvers::Customer::InitialEmptyOrder do
  subject(:resolver)  { described_class.new }
  let!(:customer)     { create :customer }
  let(:context)       { { current_user: customer } }
  let(:object)        { double(:object) }
  let(:inputs)        { double(:inputs) }

  context 'successful' do
    it { expect { resolver.call(object, inputs, context) }.to change(Order, :count).by(1) }
  end

  context 'failure (customer is not authorized)' do
    let!(:customer) { nil }

    it { expect { resolver.call(object, inputs, context) }.to raise_error 'You are not authorized' }
  end
end

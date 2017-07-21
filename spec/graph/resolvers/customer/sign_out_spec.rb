require 'rails_helper'

describe Resolvers::Customer::SignOut do
  subject(:resolver) { described_class.new }

  let!(:customer) { create :customer, email: 'test@example.com' }
  let(:inputs)    { { email: 'test@example.com' } }
  let(:object)    { double :object }

  context 'successful' do
    let(:context) { { helpers: { sign_out: double }, current_user: customer } }
    before { allow(context[:helpers][:sign_out]).to receive(:call) { true } }

    specify do
      expect { resolver.call(object, inputs, context) }.not_to raise_error
    end
  end

  context 'fail' do
    let(:context) { { helpers: { sign_out: double }, current_user: nil } }

    specify do
      expect { resolver.call(object, inputs, context) }.to raise_error('User have been logout already')
    end
  end
end

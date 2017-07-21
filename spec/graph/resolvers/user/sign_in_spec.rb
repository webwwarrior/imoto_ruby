require 'rails_helper'

describe Resolvers::User::SignIn do
  subject(:resolver) { described_class.new }

  let!(:photographer) do
    create :photographer, email: 'photographer@example.com', password: 'password', password_confirmation: 'password'
  end
  let!(:customer) do
    create :customer, email: 'customer@example.com', password: 'password', password_confirmation: 'password'
  end
  let(:photographer_inputs) { { 'email' => 'photographer@example.com', 'password' => 'password' } }
  let(:customer_inputs)     { { 'email' => 'customer@example.com',     'password' => 'password' } }
  let(:context)             { { helpers: { sign_in: double } } }
  let(:object)              { double :object }

  context 'successful' do
    before { expect(context[:helpers][:sign_in]).to receive(:call) { true } }

    specify do
      expect { resolver.call(object, customer_inputs, context) }.not_to raise_error
    end
    specify do
      expect { resolver.call(object, photographer_inputs, context) }.not_to raise_error
    end

    it { expect(resolver.call(object, customer_inputs, context)[:user]).to be_kind_of(Customer) }
    it { expect(resolver.call(object, photographer_inputs, context)[:user]).to be_kind_of(Photographer) }
  end

  context 'fail' do
    let(:inputs1) { { 'email' => 'another@mail.com' } }
    let(:inputs2) { { 'email' => 'test@example.com', 'password' => 'invalid_password' } }

    specify do
      expect { resolver.call(object, inputs1, context) }.to raise_error('Invalid email or password')
      expect { resolver.call(object, inputs2, context) }.to raise_error('Invalid email or password')
    end
  end
end

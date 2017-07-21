require 'rails_helper'

describe Resolvers::Customer::ResetPassword do
  subject(:resolver) { described_class.new }

  let!(:customer) { create :customer }
  let(:inputs) do
    { 'reset_password_token' => 'reset_password_token',
      'password' => 'password',
      'password_confirmation' => 'password' }
  end
  let(:object)  { double :object }
  let(:context) { double :context }

  context 'successful' do
    before { expect(Customer).to receive(:with_reset_password_token) { customer } }

    specify do
      expect { resolver.call(object, inputs, context) }.not_to raise_error
    end
  end

  context 'fail::invalid token' do
    let(:invalid_inputs) { inputs.merge('reset_password_token' => 'valid') }

    before do
      expect(Customer).to receive(:with_reset_password_token)
        .with(invalid_inputs['reset_password_token']) { nil }
    end

    specify do
      expect { resolver.call(object, invalid_inputs, context) }.to raise_error('Invalid reset password token')
    end
  end

  context 'fail::invalid token' do
    let(:invalid_inputs) { inputs.merge('password_confirmation' => 'valid') }

    before { expect(Customer).to receive(:with_reset_password_token) { customer } }

    specify do
      expect { resolver.call(object, invalid_inputs, context) }
        .to raise_error('Your password and password confirmation do not coincide')
    end
  end
end

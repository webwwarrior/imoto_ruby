require 'rails_helper'

describe Resolvers::Customer::SendResetPasswordInstruction do
  subject(:resolver) { described_class.new }

  let!(:сustomer) { create :customer, email: 'test@example.com' }
  let(:inputs)    { { 'email' => 'test@example.com' } }
  let(:object)    { double :object }
  let(:context)   { double :context }

  context 'successful' do
    specify do
      expect { resolver.call(object, inputs, context) }.not_to raise_error
    end
  end

  context 'fail' do
    let(:inputs) { { 'email' => 'another@mail.com' } }

    specify do
      expect { resolver.call(object, inputs, context) }
        .to raise_error("Can not find user with email #{inputs['email']}")
    end
  end
end

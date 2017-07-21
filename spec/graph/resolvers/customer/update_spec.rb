require 'rails_helper'

describe Resolvers::Customer::Update do
  subject(:resolver) { described_class.new }

  let(:context) { { current_user: customer } }
  let(:object)  { double :object }
  let!(:customer) do
    create :customer, email: 'email@example.com', password: 'password', password_confirmation: 'password',
                      company: company, role: :agent
  end
  let!(:company) { create :company, name: 'Initial Company Name' }

  let(:inputs) do
    { 'email'    => 'new_email@example.com',
      'password' => 'new_password',
      'password_confirmation' => 'new_password',
      'role' => 'agent' }
  end

  context 'successful' do
    specify do
      expect { resolver.call(object, inputs, context) }
        .to change { customer.email }.from('email@example.com').to('new_email@example.com')
    end
    specify do
      expect { resolver.call(object, inputs, context) }
        .to change { customer.password }.from('password').to('new_password')
    end
    specify do
      expect { resolver.call(object, inputs, context) }.not_to change { Company.count }
    end
  end

  context 'failure (invalid password confirmation)' do
    let(:inputs2) { inputs.merge('password_confirmation' => 'invalid') }
    let(:inputs3) { inputs.merge('password_confirmation' => nil) }

    specify do
      expect { resolver.call(object, inputs2, context) }
        .to raise_error "Invalid input for Customer: Password confirmation doesn't match Password"
      expect { resolver.call(object, inputs3, context) }
        .to raise_error 'Password confirmation can not be blank'
    end
  end
end

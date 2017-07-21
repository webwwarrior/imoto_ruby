require 'rails_helper'

describe Resolvers::Customer::Create do
  subject(:resolver) { described_class.new }

  let(:context)  { { helpers: { sign_in: double }, attachments: { 'customer_avatar' => file } } }
  let(:object)   { double :object }
  let!(:company) { create :company, id: 5 }
  let!(:file)    { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'assets', 'test.jpg')) }

  let!(:inputs) do
    { 'email'    => 'email@example.com',
      'password' => 'password',
      'password_confirmation' => 'password',
      'role' => 'agent',
      'avatar' => '#!file:customer_avatar',
      'company_id' => '5' }
  end

  context 'successful' do
    before { expect(context[:helpers][:sign_in]).to receive(:call) { true } }

    it { expect { resolver.call(object, inputs, context) }.to change(Customer, :count).by(1) }
    it { expect { resolver.call(object, inputs, context) }.not_to change(Company, :count) }
    it { expect(resolver.call(object, inputs, context)[:customer].company).to eq(company) }
    it { expect(resolver.call(object, inputs, context)[:customer].avatar.filename).to eq 'test.jpg' }
  end

  context 'failure (invalid password confirmation)' do
    let!(:inputs) do
      { 'email'    => 'email@example.com',
        'password' => 'password',
        'password_confirmation' => 'valid' }
    end

    specify do
      expect { resolver.call(object, inputs, context) }.not_to change { Customer.count }
    end
  end
end

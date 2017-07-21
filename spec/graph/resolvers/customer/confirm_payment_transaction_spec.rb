require 'rails_helper'

describe Resolvers::Customer::ConfirmPaymentTransaction do
  subject(:resolver) { described_class.new }
  let!(:customer)    { create :customer }
  let(:context)      { { current_user: customer } }
  let(:object)       { double :object }
  let!(:order)       { create :order, customer: customer, id: 1 }
  let!(:inputs)      { { 'order_id' => 1, 'trans_id' => '1234', 'save_credit_card' => true } }

  before do
    allow_any_instance_of(described_class).to receive(:create_payment_transaction)
      .with(inputs, order) { true }
  end

  it { expect(resolver.call(object, inputs, context)[:order].step).to eq 'confirmed' }
end

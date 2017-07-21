require 'rails_helper'

describe Resolvers::Customer::ProductOrderDetails do
  subject(:resolver) { described_class.new }
  let!(:customer)    { create :customer }
  let(:context)      { { current_user: customer } }
  let(:object)       { double :object }
  let!(:order)       { create :order, customer: customer, id: 1 }
  let!(:product)     { create :product, name: 'Photos' }
  let!(:attribute1) do
    create :attribute_item, :switch, id: 1, product: product, base_quantity: 1, base_price: 10,
                                     data: { label: 'Video', description: 'Test description' }
  end
  let!(:attribute2) do
    create :attribute_item, :dependent_select, id: 2, product: product, base_quantity: 10, base_price: 100,
                                               additional_price: 50
  end

  let!(:inputs) do
    {
      'order_id' => '1',
      'attributes' => [
        {
          'id' => '1',
          'data' => [{ 'key' => 'label', 'value' => 'Extended Hosting' }],
          'quantity' => '1'
        },
        {
          'id' => '2',
          'data' => [
            {
              'key' => 'Room',
              'value' => '123'
            },
            {
              'key' => 'Bathroom',
              'value' => '25'
            }
          ],
          'quantity' => '11'
        }
      ]
    }
  end

  context 'successful' do
    specify do
      expect { resolver.call(object, inputs, context) }.to change(OrderAttribute, :count).by(2)
    end
  end

  context 'failure (invalid quantity)' do
    let!(:attribute1) do
      create :attribute_item, id: 1, product: product, kind: :switch, base_quantity: 10, base_price: 10,
                              data: { label: 'Video', description: 'Test description' }
    end

    specify do
      expect { resolver.call(object, inputs.merge(city: ''), context) }
        .to raise_error 'Invalid product quantity'
    end
  end
end

require 'rails_helper'

describe OrderAttribute do
  it { is_expected.to belong_to(:order) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :quantity }
  it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to 1 }
  it { is_expected.to validate_numericality_of(:price).is_greater_than 0 }

  describe '::for_product' do
    let!(:product1)    { create :product }
    let!(:product2)    { create :product }
    let!(:order_attr1) { create :order_attribute, attribute_item: attribute_item1 }
    let!(:order_attr2) { create :order_attribute, attribute_item: attribute_item1 }
    let!(:order_attr3) { create :order_attribute, attribute_item: attribute_item2 }
    let!(:attribute_item1)  { create :attribute_item, :input, product: product1 }
    let!(:attribute_item2)  { create :attribute_item, :input, product: product2 }

    specify do
      expect(described_class.for_product(product1.id)).to contain_exactly(order_attr1, order_attr2)
      expect(described_class.for_product(product2.id)).to contain_exactly(order_attr3)
    end
  end

  describe '::parent_item_ids' do
    let!(:attribute_item1)  { create :attribute_item, :input, parent_id: nil }
    let!(:attribute_item2)  { create :attribute_item, :input, parent_id: attribute_item1.id }
    let!(:attribute_item3)  { create :attribute_item, :input, parent_id: nil }
    let!(:attribute_item4)  { create :attribute_item, :input, parent_id: attribute_item1.id }
    let!(:order_attr1) { create :order_attribute, attribute_item: attribute_item1 }
    let!(:order_attr2) { create :order_attribute, attribute_item: attribute_item1 }
    let!(:order_attr3) { create :order_attribute, attribute_item: attribute_item2 }
    let!(:order_attr4) { create :order_attribute, attribute_item: attribute_item3 }
    let!(:order_attr5) { create :order_attribute, attribute_item: attribute_item4 }

    it { expect(described_class.parent_item_ids).to contain_exactly(attribute_item1.id, attribute_item3.id) }
  end

  describe '::with_uncompleted_orders' do
    let!(:order1) { create :order, status: :completed }
    let!(:order2) { create :order, status: :pending }
    let!(:attr_item)   { create :attribute_item, :input }
    let!(:order_attr1) { create :order_attribute, attribute_item: attr_item, order: order1 }
    let!(:order_attr2) { create :order_attribute, attribute_item: attr_item, order: order2 }
    let!(:order_attr3) { create :order_attribute, attribute_item: attr_item, order: order2 }

    it { expect(described_class.with_uncompleted_orders).to contain_exactly(order_attr2, order_attr3) }
  end

  describe '#formatted_data' do
    let!(:order_attr1) do
      create :order_attribute, attribute_item: attr1, data: { '25 Photos' => '25' }
    end
    let!(:order_attr2) do
      create :order_attribute, attribute_item: attr2, data: { 'Room' => '1000', 'Bedroom' => '2000' }
    end
    let!(:order_attr3) do
      create :order_attribute, attribute_item: attr3, data: { 'square meters' => '35' }
    end

    let!(:attr1) do
      create :attribute_item, :single_select, base_price: 50, base_quantity: 25, additional_price: 3,
                                              data: { '25' => '25 Photos', '35' => '35 Photos' }
    end
    let!(:attr2) do
      create :attribute_item, :dependent_select, base_price: 5, base_quantity: 1, additional_price: 5,
                                                 data: { 'quantity_range' => %w(1 2), 'main_select_label' => 'Photo',
                                                         'subselect_labels' => %w(Room Bedroom) }
    end
    let!(:attr3) do
      create :attribute_item, :input, base_price: 500, base_quantity: 1, additional_price: 0,
                                      data: { 'unit' => 'sq/ft', 'note' => 'square meters', kind: 'float' }
    end

    let(:result1) { [{ key: '25 Photos', value: '25' }] }
    let(:result2) { [{ key: 'Room', value: '1000' }, { key: 'Bedroom', value: '2000' }] }

    specify do
      expect(order_attr1.formatted_data).to eq result1.to_json
      expect(order_attr2.formatted_data).to eq result2.to_json
      expect(order_attr3.formatted_data).to eq ['35'].to_json
    end
  end
end

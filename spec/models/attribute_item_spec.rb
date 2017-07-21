require 'rails_helper'

describe AttributeItem do
  it { is_expected.to belong_to(:company) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_many(:order_attributes) }
  it { is_expected.to have_many(:photographer_attributes).dependent(:destroy) }
  it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:base_quantity).is_greater_than_or_equal_to(1) }
  it { is_expected.to validate_numericality_of(:additional_price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:base_quantity) }
  it { is_expected.to validate_presence_of(:additional_price) }

  it do
    is_expected.to define_enum_for(:kind)
      .with([:switch, :single_select, :order_details, :input, :dependent_select, :hidden, :tags, :upload])
  end

  context 'if listing' do
    before { allow(subject).to receive(:order_details?).and_return(true) }

    it { is_expected.to validate_presence_of :base_price }
  end

  describe 'scopes' do
    let!(:company) { create :company }
    let!(:attr1)   { create :attribute_item, :switch, company_id: nil }
    let!(:attr2)   { create :attribute_item, :switch, company: company, parent_id: attr1.id }
    let!(:attr3)   { create :attribute_item, :switch, company_id: nil }
    let!(:attr4)   { create :attribute_item, :switch, company: company, parent_id: attr3.id }

    describe '::basic' do
      context 'without company' do
        it { expect(described_class.basic(nil)).to contain_exactly(attr1, attr3) }
      end

      context 'without records' do
        it { expect(described_class.basic(company.id)).to be_empty }
      end

      context 'with records' do
        let!(:attr5) { create :attribute_item, :switch, company_id: nil }

        it { expect(described_class.basic(company.id)).to contain_exactly(attr5) }
      end
    end

    context '::customized' do
      it { expect(described_class.customized(company.id)).to contain_exactly(attr2, attr4) }
    end
  end

  describe '#customized_attribute' do
    let!(:photographer) { create :photographer }

    let!(:attr1) { create :attribute_item, :switch, company_id: nil }
    let!(:attr2) { create :attribute_item, :switch, company_id: nil }
    let!(:attr3) { create :attribute_item, :switch, company_id: nil }
    let!(:attr4) { create :attribute_item, :switch, company_id: nil }

    let!(:photographer_attr1) { create :photographer_attribute, attribute_item: attr1, photographer: photographer }
    let!(:photographer_attr2) { create :photographer_attribute, attribute_item: attr2, photographer: photographer }

    it { expect(attr1.customized_attribute(photographer.id)).to eq photographer_attr1 }
    it { expect(attr2.customized_attribute(photographer.id)).to eq photographer_attr2 }
    it { expect(attr3.customized_attribute(photographer.id)).to eq nil }
    it { expect(attr4.customized_attribute(photographer.id)).to eq nil }
  end

  describe '#total_price' do
    let(:attribute_item) { create :attribute_item, :hidden, base_quantity: 10, base_price: 100, additional_price: 30 }

    it { expect(attribute_item.total_price(15)).to eq 250.to_d }
  end

  describe '#name' do
    let(:product) { create :product, name: 'Product Name' }
    let(:attribute_item1) { create :attribute_item, :hidden, product: product }
    let(:attribute_item2) do
      create :attribute_item, :switch, data: { label: 'Branded Tour', description: 'Test description' }
    end

    specify do
      expect(attribute_item1.name).to eq 'Product Name'
      expect(attribute_item2.name).to eq 'Branded Tour'
    end
  end

  describe '#extended_name' do
    let(:product) { create :product, name: 'Product Name' }
    let(:product2) { create :product, name: 'More Add/ons' }
    let(:attribute_item1) { create :attribute_item, :hidden, product: product }
    let(:attribute_item2) do
      create :attribute_item, :switch, data: { label: 'Branded Tour', description: 'Test description' },
                                       product: product2
    end

    specify do
      expect(attribute_item1.extended_name).to eq 'Product Name'
      expect(attribute_item2.extended_name).to eq 'More Add/ons (Branded Tour)'
    end
  end

  describe '#kind_name' do
    let(:attribute_item) { create :attribute_item, :dependent_select }

    it { expect(attribute_item.kind_name).to eq 'Dependent select' }
  end

  describe '#formatted_data' do
    let!(:attr1) do
      create :attribute_item, :single_select, base_price: 50, base_quantity: 25, additional_price: 3,
        data: { '25' => '50', '35' => '80.5' }
    end
    let!(:attr2) do
      create :attribute_item, :upload, base_price: 500, base_quantity: 1, additional_price: 0,
                                       data: { 'extensions' => %w(png pdf jpg) }
    end
    let!(:attr3) do
      create :attribute_item, :dependent_select, base_price: 5, base_quantity: 1, additional_price: 5,
                                                 data: { 'quantity_range' => %w(1 3), 'main_select_label' => 'Photo',
                                                         'subselect_labels' => %w(Room Bedroom Bathroom) }
    end
    let(:result1) do
      [{ label: '25 Photos', value: '25', price: '50.0' },
       { label: '35 Photos', value: '35', price: '80.5' }]
    end
    let(:result2) do
      { main_select: [{ label: '1 Photo', value: 1, price: '5.0' },
                      { label: '2 Photos', value: 2, price: '10.0' },
                      { label: '3 Photos', value: 3, price: '15.0' }],
        dependent_select: [{ label: 'Room', value: 'Room' },
                           { label: 'Bedroom', value: 'Bedroom' },
                           { label: 'Bathroom', value: 'Bathroom' }] }
    end

    specify do
      expect(attr1.formatted_data).to eq result1.to_json
      expect(attr2.formatted_data).to eq attr2.data.to_json
      expect(attr3.formatted_data).to eq result2.to_json
    end
  end
end

require 'rails_helper'

describe Order do
  it { is_expected.to define_enum_for(:status).with(%i(pending in_progress completed)) }
  it do
    is_expected.to define_enum_for(:step).with(
      %i(initial listing listing_confirmation products_selection photographer_selection billing confirmed)
    )
  end
  it { is_expected.to belong_to :coupon }
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :photographer }
  it { is_expected.to have_many :orders_products }
  it { is_expected.to have_many(:products).through(:orders_products) }
  it { is_expected.to have_many(:order_attributes).dependent(:destroy) }

  context 'if listing' do
    before { allow(subject).to receive(:listing?).and_return(true) }

    it { is_expected.to validate_presence_of :state }
    it { is_expected.to validate_presence_of :zip_code }
  end

  context 'if listing_confirmation' do
    before { allow(subject).to receive(:listing_confirmation?).and_return(true) }

    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :city }
    it { is_expected.to validate_presence_of :listing_price }
    it { is_expected.to validate_presence_of :square_footage }
    it { is_expected.to validate_presence_of :number_of_beds }
    it { is_expected.to validate_presence_of :number_of_baths }
  end

  context 'if photographer_selection' do
    before { allow(subject).to receive(:photographer_selection?).and_return(true) }

    it { is_expected.to validate_presence_of :photographer_id }
    it { is_expected.to validate_presence_of :event_started_at }
  end

  describe '#full_address' do
    let(:order) { create :order, city: 'Labelle', zip_code: '33935', state: 'Florida', address: 'Shevchenko AVE 1' }

    it { expect(order.full_address).to eq 'LABELLE, 33935, Florida. Shevchenko AVE 1' }
  end

  describe '#execution_time' do
    let!(:order) { create :order, event_started_at: DateTime.new(2017, 11, 20, 10, 27, 01) }
    let!(:order_attributes1) { create :order_attribute, estimated_time: 30, order: order }
    let!(:order_attributes2) { create :order_attribute, estimated_time: 95, order: order }

    it { expect(order.execution_time).to eq DateTime.new(2017, 11, 20, 12, 32, 01) }
  end

  describe '#by_id_and_customer_name' do
    let!(:customer1)     { create :customer, full_name: 'Oleksandr Euro' }
    let!(:customer2)     { create :customer, full_name: 'Igor Grivna' }
    let!(:customer3)     { create :customer, full_name: 'Vova Dolar' }
    let!(:customer4)     { create :customer, full_name: 'Artur Frank' }

    let!(:order1)        { create :order, customer: customer1 }
    let!(:order2)        { create :order, customer: customer2 }
    let!(:order3)        { create :order, customer: customer3 }
    let!(:order4)        { create :order, customer: customer4 }

    subject { Order.by_id_and_customer_name(id, name) }

    context 'search by name and id' do
      let!(:name) { 'Igor Grivna' }
      let!(:id)   { order3.id }
      it { expect(subject).to eq [order2, order3] }
    end

    context 'search by name' do
      let!(:name) { 'Artur' }
      let!(:id)   { nil }
      it { expect(subject).to eq [order4] }
    end

    context 'search be id' do
      let!(:name) { '' }
      let!(:id)   { order1.id }
      it { expect(subject).to eq [order1] }
    end
  end

  describe '#total_price' do
    let!(:order) { create :order }
    let!(:order_attributes1) { create :order_attribute, price: 30, order: order }
    let!(:order_attributes2) { create :order_attribute, price: 70, order: order }

    it { expect(order.total_price).to eq 100.0 }
  end

  describe '#price_with_discount' do
    let!(:order1) { create :order, coupon: coupon1 }
    let!(:order2) { create :order, coupon: coupon2 }
    let!(:order3) { create :order, coupon: nil }
    let(:coupon1) { create :coupon, discount_amount: 10, discount_type: :percentage }
    let(:coupon2) { create :coupon, discount_amount: 20, discount_type: :flat_amount }
    let!(:order_attributes1) { create :order_attribute, price: 30, order: order1 }
    let!(:order_attributes2) { create :order_attribute, price: 70, order: order1 }
    let!(:order_attributes3) { create :order_attribute, price: 70, order: order2 }
    let!(:order_attributes4) { create :order_attribute, price: 40, order: order3 }

    specify do
      expect(order1.price_with_discount).to eq 90.0
      expect(order2.price_with_discount).to eq 50.0
      expect(order3.price_with_discount).to eq 40.0
    end
  end

  describe '#attribute_ids_with_qauntity' do
    let!(:order) { create :order }
    let!(:attribute_item1) { create :attribute_item, :upload, id: 11 }
    let!(:attribute_item2) { create :attribute_item, :upload, id: 22, parent_id: 11 }
    let!(:attribute_item3) { create :attribute_item, :upload, id: 33 }
    let!(:order_attr1) { create :order_attribute, id: 1, price: 30, quantity: 4, order: order, attribute_item_id: 22 }
    let!(:order_attr2) { create :order_attribute, id: 2, price: 70, quantity: 10, order: order, attribute_item_id: 33 }
    let(:result) { [[11, 4], [33, 10]] }

    it { expect(order.attribute_ids_with_qauntity).to eq result }
  end
end

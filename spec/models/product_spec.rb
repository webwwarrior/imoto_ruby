require 'rails_helper'

describe Product do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to define_enum_for(:status).with([:disabled, :enabled]) }
  it { is_expected.to belong_to :category }
  it { is_expected.to have_many :orders_products }
  it { is_expected.to have_many(:orders).through(:orders_products) }
  it { is_expected.to have_many(:attribute_items).dependent(:destroy).inverse_of(:product) }
  it { is_expected.to accept_nested_attributes_for(:attribute_items) }

  describe '::with_attribute_items' do
    let!(:product1) { create :product }
    let!(:product2) { create :product }
    let!(:product3) { create :product }
    let!(:attr_item1) { create :attribute_item, :input, product: product1 }
    let!(:attr_item2) { create :attribute_item, :input, product: product1 }
    let!(:attr_item3) { create :attribute_item, :input, product: product2 }
    let!(:attr_item4) { create :attribute_item, :input, product: product3 }

    specify do
      expect(described_class.with_attribute_items([attr_item1.id, attr_item2.id])).to contain_exactly(product1)
      expect(described_class.with_attribute_items([attr_item3.id, attr_item4.id]))
        .to contain_exactly(product2, product3)
    end
  end
end

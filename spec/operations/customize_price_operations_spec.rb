require 'spec_helper'

describe CustomizePriceOperations do
  describe '.create' do
    let!(:attribute) { create :attribute_item, :switch }
    let!(:company)   { create :company }

    specify do
      CustomizePriceOperations.create(attribute.id, company)

      expect(AttributeItem.count).to eq(2)

      AttributeItem.last.tap do |object|
        expect(object.data['label']).to eq attribute.data['label']
        expect(object.base_price).to eq attribute.base_price
        expect(object.parent_id).to eq attribute.id
        expect(object.company_id).to eq company.id
      end
    end
  end
end

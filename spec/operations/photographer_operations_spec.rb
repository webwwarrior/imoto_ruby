require 'spec_helper'

describe PhotographerOperations do
  describe '.update' do
    let!(:photographer)   { create :photographer }
    let!(:attribute_item) { create :attribute_item, :switch }
    let!(:photographer_params) do
      {
        photographer: {
          first_name: 'Oleksandr',
          last_name: 'Test',
          email: 'test@mail.com',
          default_time_zone: 'America/Nome',
          photographer_attributes_attributes: [
            {
              attribute_item_id: attribute_item.id,
              default_time: 10,
              extra_time: 20,
              rate: 30,
              additional_rate: 35
            }
          ]
        }
      }
    end
    let!(:params) { ActionController::Parameters.new(photographer_params) }

    specify do
      PhotographerOperations.update(photographer, params)
      photographer.reload

      expect(PhotographerAttribute.count).to eq(1)

      photographer.photographer_attributes.last.tap do |object|
        expect(object.attribute_item_id).to eq attribute_item.id
        expect(object.default_time).to eq 10
        expect(object.extra_time).to eq 20
        expect(object.rate).to eq 30
        expect(object.additional_rate).to eq 35
      end
    end
  end

  describe '.create' do
    subject { PhotographerOperations.create(params) }

    context 'success' do
      let!(:params) do
        {
          first_name: 'Oleksandr',
          last_name: 'Test',
          email: 'test@mail.com',
          default_time_zone: 'America/Nome'
        }
      end

      it { expect { subject }.to change(Photographer, :count).by(1) }
    end

    context 'failed' do
      let!(:params) do
        {
          first_name: 'Oleksandr',
          last_name: 'Test'
        }
      end

      it { expect { subject }.to change(Photographer, :count).by(0) }
    end
  end
end

require 'rails_helper'

describe Admin::PhotographersController do
  before { allow(controller).to receive(:authenticate_admin!).and_return true }
  describe 'POST #create' do
    subject { post :create, params: params }

    context 'success' do
      let!(:params) do
        {
          photographer: {
            first_name: 'Oleksandr',
            last_name: 'Test',
            email: 'test@mail.com',
            default_time_zone: 'America/Nome'
          }
        }
      end

      it { expect { subject }.to change(Photographer, :count).by(1) }
    end

    context 'failed' do
      let!(:params) do
        {
          photographer: {
            first_name: 'Oleksandr',
            last_name: 'Test',
            default_time_zone: 'America/Nome'
          }
        }
      end

      it { expect { subject }.to change(Photographer, :count).by(0) }
    end
  end

  describe 'PUT #update' do
    let!(:photographer) { create :photographer, email: 'oleksandr@gmail.com' }
    let!(:attribute) { create :attribute_item, :switch }

    context 'success' do
      let!(:params) do
        {
          photographer: {
            first_name: 'Oleksandr',
            last_name: 'Test',
            email: 'test@mail.com',
            default_time_zone: 'America/Nome',
            photographer_attributes_attributes: [
              {
                attribute_item_id: attribute.id,
                default_time: 40,
                extra_time: 55,
                rate: 2,
                additional_rate: 35
              }
            ]
          },
          id: photographer.id
        }
      end

      before do
        put :update, params: params
        photographer.reload
      end

      specify 'photographer' do
        expect(photographer.first_name).to eq 'Oleksandr'
        expect(photographer.last_name).to eq 'Test'
        expect(photographer.email).to eq 'test@mail.com'
      end

      specify do
        PhotographerAttribute.last.tap do |object|
          expect(object.default_time).to eq 40
          expect(object.extra_time).to eq 55
          expect(object.rate).to eq 2
          expect(object.additional_rate).to eq 35
        end
      end
    end

    context 'failed' do
      let!(:params) do
        {
          photographer: {
            first_name: 'Oleksandr',
            last_name: 'Test',
            email: 'bla',
            default_time_zone: 'America/Nome',
            photographer_attributes_attributes: [
              {
                attribute_item_id: attribute.id,
                default_time: 40,
                extra_time: 55,
                rate: 2,
                additional_rate: 35
              }
            ]
          },
          id: photographer.id
        }
      end

      before do
        put :update, params: params
        photographer.reload
      end

      it { expect(photographer.photographer_attributes.count).to eq 0 }
      it { expect(photographer.email).to eq 'oleksandr@gmail.com' }
    end
  end
end

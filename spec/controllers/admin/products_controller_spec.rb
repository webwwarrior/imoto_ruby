require 'rails_helper'

describe Admin::ProductsController do
  let(:admin) { create :admin }
  before { sign_in admin }

  describe 'POST #create' do
    context 'switch' do
      context 'success' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '2.5',
                kind: 'switch',
                data: { label: 'Test', description: 'Test description' }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(1) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(1) }
      end

      context 'failed' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '',
                additional_price: '',
                base_quantity: '2.5',
                kind: 'switch',
                data: { label: 'Test', description: 'Test description' }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(0) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(0) }
      end
    end

    context 'hidden' do
      context 'success' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: 100,
                additional_price: 25,
                base_quantity: 2.5,
                kind: 'hidden',
                data: {}
              }, {
                base_price: 200,
                additional_price: 50,
                base_quantity: 5,
                kind: 'hidden',
                data: {}
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(1) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(2) }
      end

      context 'failed' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '',
                kind: 'hidden',
                data: {}
              }, {
                ase_price: '200',
                additional_price: '50',
                base_quantity: '5',
                kind: 'hidden',
                data: {}
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(0) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(0) }
      end
    end

    context 'input' do
      context 'success' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '2.5',
                kind: 'input',
                data: { unit: '2500', note: 'sq/ft', kind: 'number' }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(1) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(1) }
      end

      context 'failed' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '',
                kind: 'input',
                data: { unit: '', note: 'sq/ft' }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(0) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(0) }
      end
    end

    context 'single_select' do
      context 'success' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '2.5',
                kind: 'single_select',
                data: { quantity: %w(25 35), price: %w(50 80.5) }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(1) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(1) }
      end

      context 'failed with empty params' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                additional_price: '25',
                base_quantity: '10',
                kind: 'single_select',
                data: { quantity: %w(25 35), price: %w(50 80.5) }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(0) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(0) }
      end

      context 'failed with base_price less quantity to options' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '1',
                additional_price: '25',
                base_quantity: '45',
                kind: 'single_select',
                data: { quantity: %w(25 35), price: %w(50 80.5) }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(0) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(0) }
      end
    end

    context 'dependent_select' do
      context 'success' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '2.5',
                kind: 'dependent_select',
                data: { main_select_label: 'test', quantity_range: %w(1 10), subselect_labels: %w(t1 t2) }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(1) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(1) }
      end

      context 'failed' do
        let(:params) do
          {
            product: {
              name: 'Test',
              status: 'enabled',
              attribute_items_attributes: [{
                base_price: '100',
                additional_price: '25',
                base_quantity: '',
                kind: 'dependent_select',
                data: { main_select_label: '', quantity_range: [], subselect_labels: %w(t1 t2) }
              }]
            }
          }
        end

        it { expect { post :create, params: params }.to change(Product, :count).by(0) }
        it { expect { post :create, params: params }.to change(AttributeItem, :count).by(0) }
      end
    end
  end

  describe 'PUT #update' do
    let!(:product) { create :product, name: 'old test' }
    let!(:attribute) do
      create :attribute_item, :dependent_select, base_price: 100, product: product
    end

    let(:params) do
      {
        id: product.id,
        product: {
          name: 'new test',
          status: 'enabled',
          attribute_items_attributes: [{
            id: attribute.id,
            base_price: '100',
            additional_price: '45',
            base_quantity: '2',
            kind: 'dependent_select',
            data: { main_select_label: 'Photo', quantity_range: %w(1 30), subselect_labels: %w(Room Bedroom) }
          }]
        }
      }
    end

    context 'success' do
      before { put :update, params: params }
      before { product.reload }
      before { attribute.reload }

      it { expect(product.name).to eq 'new test' }

      specify 'attribute' do
        expect(attribute.base_price).to eq 100
        expect(attribute.additional_price).to eq 45
        expect(attribute.base_quantity).to eq 2
        expect(attribute.data['main_select_label']).to eq 'Photo'
        expect(attribute.data['quantity_range']).to eq %w(1 30)
        expect(attribute.data['subselect_labels']).to eq %w(Room Bedroom)
      end
    end

    context 'when product is invalid' do
      let(:params) do
        {
          id: product.id,
          product: {
            name: nil,
            status: 'enabled',
            attribute_items_attributes: [{
              id: attribute.id,
              base_price: '100',
              additional_price: '45',
              base_quantity: '2',
              kind: 'dependent_select',
              data: { main_select_label: 'Photo', quantity_range: %w(1 30), subselect_labels: %w(Room Bedroom) }
            }]
          }
        }
      end

      before { put :update, params: params }
      before { product.reload }
      before { attribute.reload }

      it { expect(product.name).to eq 'old test' }
      it { expect(response).to render_template :edit }
    end

    context 'failed with attribute don`t valid' do
      let(:params) do
        {
          id: product.id,
          product: {
            name: 'new test',
            status: 'enabled',
            attribute_items_attributes: [{
              id: attribute.id,
              base_price: nil,
              additional_price: '45',
              base_quantity: nil,
              kind: 'dependent_select',
              data: { main_select_label: 'Photo', quantity_range: %w(1 30), subselect_labels: %w(Room Bedroom) }
            }]
          }
        }
      end

      before { put :update, params: params }
      before { product.reload }
      before { attribute.reload }

      it { expect(product.name).to eq 'old test' }
      specify 'attribute' do
        expect(attribute.base_price).to eq 100.0
        expect(attribute.additional_price).to eq 2.5
        expect(attribute.base_quantity).to eq 25
        expect(attribute.data['main_select_label']).to eq 'Photo'
        expect(attribute.data['quantity_range']).to eq %w(1 10)
        expect(attribute.data['subselect_labels']).to eq %w(Room Bedroom Bathroom)
      end
    end

    context 'success with delete attribute' do
      let!(:attribute1) do
        create :attribute_item, :dependent_select, product: product
      end

      let!(:attribute2) do
        create :attribute_item, :switch, product: product
      end

      it { expect { put :update, params: params }.to change(AttributeItem, :count).by(-2) }
    end
  end
end

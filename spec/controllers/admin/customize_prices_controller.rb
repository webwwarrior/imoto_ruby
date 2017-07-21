require 'rails_helper'

describe Admin::CustomizePricesController do
  let(:admin) { create :admin }
  let!(:product)   { create :product, name: 'test' }
  let!(:company)   { create :company }
  let!(:attribute) do
    create :attribute_item, product: product, company: company, base_quantity: 10, data: { label: 'test' }
  end

  before { sign_in admin }

  describe 'POST #create' do
    let!(:attribute) do
      create :attribute_item, product: product, base_quantity: 10, data: { label: 'test' }
    end

    subject { post :create, params: { company_id: company.id, item_id: attribute.id } }

    it { expect { subject }.to change(AttributeItem, :count).by(1) }
    it { expect(subject).to redirect_to admin_company_path(company) }
  end

  describe 'PUT #update' do
    before { put :update, params: { company_id: company.id, id: attribute.id, base_quantity: 20 } }
    before { attribute.reload }

    it { expect(attribute.base_quantity).to eq(20) }
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { company_id: company.id, id: attribute.id } }
    it { expect { subject }.to change(AttributeItem, :count).by(-1) }
    it { expect(subject).to redirect_to admin_company_path(company) }
    it { expect(response).to be_success }
  end
end

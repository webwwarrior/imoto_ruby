require 'rails_helper'

describe Admin::CustomersController do
  describe 'DELETE #destroy' do
    let(:admin) { create :admin }

    let!(:customer) { create :customer }
    let!(:order1)   { create :order, customer: customer, status: :completed }
    let!(:order2)   { create :order, customer: customer, status: :completed }

    before { sign_in admin }
    subject { delete :destroy, params: { id: customer.id } }

    context 'success' do
      it { expect { subject }.to change(Customer, :count).by(-1) }
      it { expect(subject).to redirect_to action: :index }
    end

    context 'failed' do
      let!(:order3) { create :order, customer: customer, status: :in_progress }

      it { expect { subject }.to change(Customer, :count).by(0) }
      it { expect(subject).to redirect_to action: :index }
    end
  end
end

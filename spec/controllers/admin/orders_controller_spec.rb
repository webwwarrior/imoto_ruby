require 'rails_helper'

describe Admin::OrdersController do
  let!(:admin)          { create :admin }

  let!(:zip_code1)      { create :zip_code, city: 'Lviv',    state_name: 'Lvivska' }
  let!(:zip_code2)      { create :zip_code, city: 'Donetsk', state_name: 'Donetska' }
  let!(:zip_code3)      { create :zip_code, city: 'Kiev',    state_name: 'Kievska' }
  let!(:zip_code4)      { create :zip_code, city: 'Lviv',    state_name: 'Lvivska' }

  let!(:photographer1) { create :photographer, zip_codes: [zip_code1, zip_code2] }
  let!(:photographer2) { create :photographer, zip_codes: [zip_code2, zip_code3] }
  let!(:photographer3) { create :photographer, zip_codes: [zip_code1] }
  let!(:photographer4) { create :photographer, zip_codes: [zip_code1, zip_code3, zip_code4] }

  let!(:photographers) { [photographer1, photographer2, photographer3, photographer4] }

  let!(:customer1)     { create :customer, full_name: 'Oleksandr Euro' }
  let!(:customer2)     { create :customer, full_name: 'Igor Grivna' }
  let!(:customer3)     { create :customer, full_name: 'Vova Dolar' }
  let!(:customer4)     { create :customer, full_name: 'Artur Frank' }

  let!(:order1)        { create :order, customer: customer1 }
  let!(:order2)        { create :order, customer: customer2 }
  let!(:order3)        { create :order, customer: customer3 }
  let!(:order4)        { create :order, customer: customer4 }

  before { sign_in admin }

  describe 'GET #index' do
    subject { get :index, params: params }

    context 'without search' do
      let!(:params) {}

      it { expect(subject).to render_template :index }
    end

    context 'search by name' do
      let!(:params) { { search: 'Oleksandr' } }
      it { expect(subject).to render_template :index }
    end

    context 'search by id' do
      let!(:params) { { search: customer2.id } }
      it { expect(subject).to render_template :index }
    end

    context 'search by name and id' do
      let!(:params) { { search: "Oleksandr #{customer2.id} Dolar" } }
      it { expect(subject).to render_template :index }
    end
  end

  describe 'GET #show' do
    subject { get :show, params: params }

    context 'without search' do
      let!(:params) { { id: order1.id } }
      it { expect(subject).to render_template :show }
    end

    context 'search by name' do
      let!(:params)    { { id: order1.id, search: 'Vova Dolar', type: 'name', date: '03-04-2017' } }
      it { expect(subject).to render_template :show }
    end

    context 'search by city' do
      let!(:params)    { { id: order1.id, search: 'Lviv', type: 'city' } }
      it { expect(subject).to render_template :show }
    end

    context 'search by state' do
      let!(:params) { { id: order2.id, search: 'Kievska', type: 'state_name' } }
      it { expect(subject).to render_template :show }
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: order3.id, photographer_id: photographer2.id, date: '04-05-2017' } }

    it { expect(subject).to render_template 'administrate/application/edit' }
  end

  describe 'PUT #update' do
    let!(:params) do
      {
        id: order4.id,
        preferred_time: '08:00AM - 10:30PM',
        date: '03-04-2017',
        travel_costs: 100,
        photographer_id: photographer3.id
      }
    end
    before { put :update, params: params }

    it { expect(response).to redirect_to admin_order_path(order4) }
  end

  describe 'DELETE #destroy' do
    before { delete :destroy, params: { id: order3.id } }
    it { expect(response).to redirect_to admin_order_path(order3) }
  end
end

require 'spec_helper'

describe OrderOperations do
  let!(:zip_code1)      { create :zip_code, city: 'Lviv',    state_name: 'Lvivska' }
  let!(:zip_code2)      { create :zip_code, city: 'Donetsk', state_name: 'Donetska' }
  let!(:zip_code3)      { create :zip_code, city: 'Kiev',    state_name: 'Kievska' }
  let!(:zip_code4)      { create :zip_code, city: 'Lviv',    state_name: 'Lvivska' }

  let!(:photographer1) do
    create :photographer,
           zip_codes: [zip_code1, zip_code2],
           first_name: 'Oleksandr',
           last_name: 'Euro',
           start_work_at: '2017-04-04 08:00:00 UTC'.to_time,
           end_work_at:   '2017-04-04 16:00:00 UTC'.to_time
  end
  let!(:photographer2) do
    create :photographer, zip_codes: [zip_code2, zip_code3], first_name: 'Igor', last_name: 'Grivna'
  end
  let!(:photographer3) do
    create :photographer,
           zip_codes:     [zip_code1],
           first_name:    'Vova',
           last_name:     'Dolar',
           start_work_at: '2017-04-04 10:00:00 UTC'.to_time,
           end_work_at:   '2017-04-04 18:00:00 UTC'.to_time
  end
  let!(:photographer4) do
    create :photographer,
           zip_codes: [zip_code1, zip_code3, zip_code4],
           first_name: 'Artur',
           last_name: 'Frank',
           start_work_at: '2017-04-04 11:00:00 UTC'.to_time,
           end_work_at:   '2017-04-04 18:00:00 UTC'.to_time
  end

  let!(:photographers) { [photographer1, photographer2, photographer3, photographer4] }

  let!(:customer1)     { create :customer, full_name: 'Oleksandr Euro' }
  let!(:customer2)     { create :customer, full_name: 'Igor Grivna' }
  let!(:customer3)     { create :customer, full_name: 'Vova Dolar' }
  let!(:customer4)     { create :customer, full_name: 'Artur Frank' }

  let!(:order1)        { create :order, customer: customer1, status: :in_progress, photographer: photographer2 }
  let!(:order2)        { create :order, customer: customer2, status: :completed }
  let!(:order3)        { create :order, customer: customer3 }
  let!(:order4)        { create :order, customer: customer4 }

  describe '.index' do
    subject { OrderOperations.index(params, Administrate::Order.new) }

    context 'search by name and id' do
      let!(:params) { container_params(search: "Igor Grivna #{order3.id}") }
      it { expect(subject).to eq [order2, order3] }
    end

    context 'search by name' do
      let!(:params) { container_params(search: 'Artur') }
      it { expect(subject).to eq [order4] }
    end

    context 'search be id' do
      let!(:params) { container_params(search: order1.id.to_s) }
      it { expect(subject).to eq [order1] }
    end
  end

  describe '.update' do
    let!(:params) do
      {
        id: order4.id,
        preferred_time: '08:00AM - 10:30PM',
        date: '03-04-2017',
        travel_costs: 100,
        photographer_id: photographer3.id
      }
    end

    specify do
      OrderOperations.update(params)
      order4.reload

      expect(order4.event_started_at).to eq '03-04-2017 08:00AM'.to_datetime
      expect(order4.travel_costs).to eq 100.00
      expect(order4.photographer_id).to eq photographer3.id
    end
  end

  describe '.destroy' do
    context 'success' do
      specify do
        OrderOperations.destroy(order1.id)
        order1.reload

        expect(order1.photographer_id).to be_nil
        expect(order1.travel_costs).to eq 0.00
        expect(order1.event_started_at).to be_nil
      end
    end

    context 'failed' do
      let!(:message) { 'Order was completed, remove photographer impossible' }
      it { expect(OrderOperations.destroy(order2.id)).to eq [order2, message] }
    end
  end

  def container_params(params)
    ActionController::Parameters.new(params)
  end
end

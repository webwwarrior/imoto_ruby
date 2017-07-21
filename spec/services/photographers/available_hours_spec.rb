require 'rails_helper'

RSpec.describe Photographers::AvailableHours do
  let!(:photographer1) do
    create :photographer, start_work_at: '08:00:00', end_work_at: '22:00:00', zip_codes: [zip_code1]
  end

  let!(:zip_code1) do
    create :zip_code, value: 339_35, state_code: 'FL', state_name: 'Florida', city: 'Labelle',
                      time_zone: 'America/New_York'
  end
  let!(:order) { create :order, zip_code: '33935' }

  let!(:attribute1) do
    create :attribute_item, :single_select,
           base_price: 10, base_quantity: 25, additional_price: 5,
           data: { quantity: %w(25 35 45), price: %w(50 80.5 100) }
  end
  let!(:attribute2) do
    create :attribute_item, :dependent_select, base_price: 5, base_quantity: 1, additional_price: 5
  end
  let!(:attribute3) do
    create :attribute_item, :input, base_price: 1000, base_quantity: 1, additional_price: 500
  end

  let!(:order_attrs1) do
    create :order_attribute, attribute_item: attribute1, quantity: 35, price: 60, name: 'Photo Shoot', order: order
  end
  let!(:order_attrs2) do
    create :order_attribute, attribute_item: attribute2, quantity: 45, price: 45, name: 'Virtual Staging', order: order
  end
  let!(:order_attrs3) do
    create :order_attribute, attribute_item: attribute3, quantity: 1, price: 1000, name: 'Floor Plan', order: order
  end

  let!(:p_attrs1) do
    create :photographer_attribute, attribute_item: attribute1, default_time: 30, extra_time: 5,
                                    photographer: photographer1
  end
  let!(:p_attrs2) do
    create :photographer_attribute, attribute_item: attribute2, default_time: 90, extra_time: 30,
                                    photographer: photographer1
  end
  let!(:p_attrs3) do
    create :photographer_attribute, attribute_item: attribute3, default_time: 45, extra_time: 30,
                                    photographer: photographer1
  end

  let!(:calendar_item1) do
    create :calendar_item,
           photographer: photographer1,
           unavailable_from: DateTime.new(2016, 10, 21, 7, 00, 00),
           unavailable_to:   DateTime.new(2016, 10, 21, 8, 00, 00)
  end
  let!(:calendar_item2) do
    create :calendar_item,
           photographer:     photographer1,
           unavailable_from: DateTime.new(2016, 10, 21, 9, 00, 00),
           unavailable_to:   DateTime.new(2016, 10, 21, 10, 00, 00)
  end
  let!(:calendar_item3) do
    create :calendar_item,
           photographer:     photographer1,
           unavailable_from: DateTime.new(2016, 10, 21, 14, 00, 00),
           unavailable_to:   DateTime.new(2016, 10, 21, 15, 30, 00)
  end

  let(:params1) { { 'date' => '2017-03-10', 'time' => '11:00 AM' } }
  let(:params2) { { 'date' => '2016-10-21', 'time' => '03:30 PM' } }

  # time of order execution is 215 minutes i.e. 3h 35m
  specify do
    expect(described_class.new(photographer1, params1, order).call)
      .to eq [DateTime.new(2017, 03, 10, 11, 00, 00)..DateTime.new(2017, 03, 10, 14, 35, 00)]
    expect(described_class.new(photographer1, params1.merge('time' => ''), order).call)
      .to eq [DateTime.new(2017, 03, 10, 8, 00, 00)..DateTime.new(2017, 03, 10, 22, 00, 00)]
    expect(described_class.new(photographer1, params2.merge('time' => ''), order).call)
      .to eq [DateTime.new(2016, 10, 21, 10, 00, 00)..DateTime.new(2016, 10, 21, 14, 00, 00),
              DateTime.new(2016, 10, 21, 15, 30, 00)..DateTime.new(2016, 10, 21, 22, 00, 00)]
    expect(described_class.new(photographer1, params2.merge('time' => '08:00 AM'), order).call).to eq []
  end
end

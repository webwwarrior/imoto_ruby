require 'rails_helper'

RSpec.describe GoogleCalendar do
  describe 'refresh_token!' do
    let!(:photographer) { create :photographer, google_access_token: '100000' }
    let(:order)         { create :order }
    let(:service)       { double :service }
    let(:calendar)      { double :calendar, id: '1' }

    subject { described_class.new(photographer, order) }

    before do
      allow(Google::Apis::CalendarV3::CalendarService).to receive(:new) { service }
      allow(service).to receive(:authorization=)    { 'google_token' }
      allow(photographer).to receive(:google_token) { 'google_token' }
      allow_any_instance_of(described_class).to receive(:find_or_initialize_calendar) { calendar }
      allow_any_instance_of(described_class).to receive(:initialize_webhooks) { true }
    end

    describe '#import_events' do
      let(:event1) do
        double :event1, id:       1212,
                        start:    double(:start1, date_time: DateTime.current),
                        end:      double(:end1, date_time: DateTime.current),
                        summary: 'First Event'
      end
      let(:event2) do
        double :event2, id: 2,
                        start: double(:start2, date_time: DateTime.current),
                        end: double(:end2, date_time: DateTime.current),
                        summary: 'Second Event'
      end

      let(:event_list) { [event1, event2] }

      let!(:calendar_item) do
        create :calendar_item, photographer: photographer, internal: true, google_calendar_event_id: '1212'
      end

      before do
        allow(service).to receive_message_chain(:list_events, :items) { event_list }
      end

      specify do
        expect { subject.import_events }.to change(CalendarItem, :count).by(1)
      end
    end

    describe '#export_event' do
      let!(:start_at) { double(:start1, date_time: DateTime.current) }
      let!(:end_at)   { double(:end1, date_time: DateTime.current) }

      let(:event) do
        double :event, id:       1,
                       start:    start_at,
                       end:      end_at,
                       summary: 'New Exported Event'
      end

      before do
        allow_any_instance_of(described_class).to receive(:new_event) { event }
        allow(service).to receive(:insert_event).with(calendar.id, event, send_notifications: true) { event }
      end

      specify do
        subject.export_event.tap do |calendar_item|
          expect(calendar_item).to eq photographer.calendar_items.last
          expect(calendar_item.google_calendar_event_id).to eq '1'
          expect(calendar_item.unavailable_from).to eq         start_at.date_time
          expect(calendar_item.unavailable_to).to eq           end_at.date_time
          expect(calendar_item.description).to eq              'New Exported Event'
          expect(calendar_item.internal).to eq                 true
        end
      end
    end
  end
end

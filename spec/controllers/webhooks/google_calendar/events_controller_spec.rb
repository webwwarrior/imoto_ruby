require 'rails_helper'

describe Webhooks::GoogleCalendar::EventsController do
  describe 'POST#create' do
    let!(:photographer1) { create :photographer, google_resource_id: 123_123 }
    let!(:photographer2) { create :photographer, google_resource_id: 321_321 }

    before do
      allow(Photographer::GoogleEventsSynchronizer).to receive(:perform_in).with(5.seconds, photographer1.id)
      request.headers['HTTP_X_GOOG_RESOURCE_ID'] = '123123'
      post :create
    end

    specify 'does something' do
      expect(Photographer::GoogleEventsSynchronizer).to have_received(:perform_in).with(5.seconds, photographer1.id)
      expect(response).to render_template(nil)
    end
  end
end

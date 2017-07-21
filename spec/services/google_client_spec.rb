require 'rails_helper'

RSpec.describe GoogleClient do
  describe 'refresh_token!' do
    let!(:photographer) { create :photographer, google_access_token: '100000' }
    let(:data) { { access_token: 'new_access_token', expires_in: '3600' }.to_json }
    let(:request_token_from_google) { double :request_token_from_google, body: data }

    subject { described_class.new(photographer) }

    before do
      allow(subject).to receive(:request_token_from_google) { request_token_from_google }
      travel_to Time.utc(2017, 1, 1, 20, 00, 00) # => 1483293600
    end

    after { travel_back }

    context 'successful' do
      specify do
        subject.refresh_token!
        expect(photographer.google_access_token).to eq 'new_access_token'
        expect(photographer.google_expires_at).to   eq 148_330_440_0
      end
    end
  end
end

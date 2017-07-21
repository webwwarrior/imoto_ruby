require 'rails_helper'

describe Photographer do
  it { is_expected.to have_many :calendar_items }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_and_belong_to_many(:zip_codes) }

  describe '#google_token' do
    let(:photographer) do
      create :photographer, google_expires_at: Time.current + 3600, google_access_token: 'access_token'
    end

    context 'valid' do
      before { allow(photographer).to receive(:google_token_valid?) { true } }

      it { expect(photographer.google_token).to eq 'access_token' }
    end

    context 'invalid' do
      before do
        allow(photographer).to receive(:google_token_valid?) { false }
        allow(GoogleClient).to receive_message_chain(:new, :refresh_token!) { 'refreshed access token' }
      end

      it { expect(photographer.google_token).to eq 'refreshed access token' }
    end
  end

  describe '#google_token_valid?' do
    before { travel_to Time.new(2004, 01, 01, 01, 01, 00) }
    after  { travel_back }
    let(:photographer1) { create :photographer, google_expires_at: Time.current.to_i - 100 }
    let(:photographer2) { create :photographer, google_expires_at: Time.current.to_i + 100 }
    let(:photographer3) { create :photographer, google_expires_at: nil }

    specify do
      expect(photographer1.google_token_valid?).to eq false
      expect(photographer2.google_token_valid?).to eq true
      expect(photographer3.google_token_valid?).to eq false
    end
  end

  describe '#full_name' do
    let(:photographer) { create :photographer, first_name: 'John', last_name: 'Doe' }

    it { expect(photographer.full_name).to eq 'John Doe' }
  end

  describe '::with_zipcode' do
    let!(:photographer1) { create :photographer, zip_codes: [zip_code1, zip_code2] }
    let!(:photographer2) { create :photographer, zip_codes: [zip_code1] }
    let!(:photographer3) { create :photographer }
    let!(:zip_code1) { create :zip_code, value: '33935', state_code: 'FL', state_name: 'Florida', city: 'Labelle' }
    let!(:zip_code2) { create :zip_code, value: '60554', state_code: 'IL', state_name: 'Illinois', city: 'Sugar Grove' }

    specify do
      expect(described_class.with_zipcode('33935')).to contain_exactly(photographer1, photographer2)
      expect(described_class.with_zipcode('60554')).to contain_exactly(photographer1)
      expect(described_class.with_zipcode('11111')).to be_empty
    end
  end

  describe '::competent' do
    let!(:attribute_item1) { create :attribute_item, :input, id: 1 }
    let!(:attribute_item2) { create :attribute_item, :input, id: 2 }
    let!(:attribute_item3) { create :attribute_item, :input, id: 3 }
    let!(:attribute_item4) { create :attribute_item, :input, id: 4 }

    let!(:photographer_attribute1) do
      create :photographer_attribute, photographer: photographer1, attribute_item: attribute_item1
    end
    let!(:photographer_attribute2) do
      create :photographer_attribute, photographer: photographer1, attribute_item: attribute_item2
    end
    let!(:photographer_attribute3) do
      create :photographer_attribute, photographer: photographer2, attribute_item: attribute_item1
    end
    let!(:photographer_attribute4) do
      create :photographer_attribute, photographer: photographer3, attribute_item: attribute_item4
    end
    let!(:photographer_attribute5) do
      create :photographer_attribute, photographer: photographer4, attribute_item: attribute_item4
    end
    let!(:photographer_attribute6) do
      create :photographer_attribute, photographer: photographer4, attribute_item: attribute_item3
    end
    let!(:photographer1) { create :photographer }
    let!(:photographer2) { create :photographer }
    let!(:photographer3) { create :photographer }
    let!(:photographer4) { create :photographer }

    specify do
      expect(described_class.competent([1, 2])).to contain_exactly(photographer1)
      expect(described_class.competent([4])).to contain_exactly(photographer3, photographer4)
      expect(described_class.competent([3])).to contain_exactly(photographer4)
      expect(described_class.competent([2, 4])).to eq []
    end
  end

  describe '#with_name' do
    let!(:photographer1) { create :photographer, first_name: 'Artur', last_name: 'Euro' }
    let!(:photographer2) { create :photographer, first_name: 'Vladimir', last_name: 'Bob' }

    it { expect(described_class.with_name('Artur', 'Euro')).to eq [photographer1] }
  end

  describe '#with_city_and_state.with_location' do
    let!(:zip_code)  { create :zip_code, state_name: 'Florida' }
    let!(:zip_code1) { create :zip_code, state_name: 'Dupka', city: 'Lviv' }
    let!(:zip_code2) { create :zip_code, state_name: 'Florida' }

    let!(:photographer1) { create :photographer, first_name: 'Artur', last_name: 'Euro', zip_codes: [zip_code] }
    let!(:photographer2) do
      create :photographer, first_name: 'Vladimir', last_name: 'Bob', zip_codes: [zip_code1, zip_code2]
    end

    subject { described_class.with_city_and_state.with_location(search, field) }

    context 'search by state_name' do
      let!(:search) { 'Florida' }
      let!(:field)  { 'state_name' }
      it { is_expected.to eq [photographer1, photographer2] }
    end

    context 'search by city' do
      let!(:search) { 'Lviv' }
      let!(:field)  { 'city' }
      it { is_expected.to eq [photographer2] }
    end
  end
end

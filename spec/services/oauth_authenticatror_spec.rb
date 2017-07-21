require 'rails_helper'

RSpec.describe OauthAuthenticator do
  let!(:auth_data) do
    OpenStruct.new(
      provider: 'google',
      uid:      '1234567',
      info: OpenStruct.new(
        email:      'bob@test.ua',
        first_name: 'Joe',
        last_name:  'Doe'
      ),
      credentials: OpenStruct.new(
        token:         'access_token',
        refresh_token: 'refresh_token',
        expires_at:    111_111
      )
    )
  end

  let!(:invalid_auth_data) do
    OpenStruct.new(
      provider: 'google',
      uid:      '1234567',
      info: OpenStruct.new(email: 'invalid_mail'),
      credentials: OpenStruct.new(
        token:         'access_token',
        refresh_token: 'refresh_token',
        expires_at:    111_111
      )
    )
  end

  describe 'With valid data' do
    context 'Create new photographer' do
      subject { OauthAuthenticator.new(auth_data) }

      specify do
        subject.photographer.tap do |photographer|
          expect(photographer).to eq Photographer.last
          expect(photographer.uid).to eq '1234567'
          expect(photographer.provider).to eq 'google'
          expect(photographer.email).to eq 'bob@test.ua'
          expect(photographer.google_access_token).to eq 'access_token'
          expect(photographer.google_refresh_token).to eq 'refresh_token'
        end
      end
    end

    context 'Update photographer account for existing Candidate' do
      let!(:photographer1) do
        create :photographer, first_name: 'Karl', last_name: 'Macanzy', email: 'bob@test.ua', uid: nil, provider: nil,
                              google_access_token: nil, google_refresh_token: nil
      end

      subject { OauthAuthenticator.new(auth_data) }

      specify do
        subject.photographer.tap do |photographer|
          expect(photographer).to eq Photographer.last
          expect(photographer.uid).to eq '1234567'
          expect(photographer.provider).to eq 'google'
          expect(photographer.email).to eq 'bob@test.ua'
          expect(photographer.google_access_token).to eq 'access_token'
          expect(photographer.google_refresh_token).to eq 'refresh_token'
        end
      end
    end
  end

  describe 'With invalid data' do
    context 'Service return nil and do not write to db' do
      subject { OauthAuthenticator.new(invalid_auth_data) }

      specify do
        expect(subject.photographer).to eq nil
        expect(Photographer.count).to eq 0
      end
    end
  end
end

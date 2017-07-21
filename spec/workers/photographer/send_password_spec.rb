require 'rails_helper'

describe Photographer::SendPassword do
  let!(:photographer) { create :photographer }

  let(:worker) { Photographer::SendPassword.new }
  let(:call)   { worker.perform(photographer.id, '1234567890') }

  specify do
    expect(PhotographerMailer).to receive(:send_password).with(photographer.id, '1234567890')
      .and_call_original
    call

    ActionMailer::Base.deliveries.last.tap do |mail|
      expect(mail).to be_present
      expect(mail.subject).to eq 'Your password for imoto'
      expect(mail.to).to eq [photographer.email]
    end
  end
end

require 'rails_helper'

describe Admin::HelpRequest do
  let!(:admin) { create :admin }

  let(:worker) { Admin::HelpRequest.new }
  let(:call)   { worker.perform('joe@example.com', 'Can not loggin', 'Help') }

  specify do
    expect(AdminMailer).to receive(:contact_request).with('joe@example.com', 'Can not loggin', 'Help')
      .and_call_original
    call

    ActionMailer::Base.deliveries.last.tap do |mail|
      expect(mail).to be_present
      expect(mail.subject).to eq 'Help'
      expect(mail.to).to eq [admin.email]
    end
  end
end

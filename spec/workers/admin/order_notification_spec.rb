require 'rails_helper'

describe Admin::OrderNotification do
  let!(:admin) { create :admin }
  let!(:order) { create :order }

  let(:worker) { Admin::OrderNotification.new }
  let(:call)   { worker.perform(order.id) }

  specify do
    expect(AdminMailer).to receive(:order_notification).with(order.id)
      .and_call_original
    call

    ActionMailer::Base.deliveries.last.tap do |mail|
      expect(mail).to be_present
      expect(mail.subject).to eq 'New Order'
      expect(mail.to).to eq [admin.email]
    end
  end
end

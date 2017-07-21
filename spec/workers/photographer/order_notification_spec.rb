require 'rails_helper'

describe Photographer::OrderNotification do
  let(:photographer) { create :photographer }
  let!(:order)       { create :order, photographer: photographer }

  let(:worker) { Photographer::OrderNotification.new }
  let(:call)   { worker.perform(order.id) }

  specify do
    expect(PhotographerMailer).to receive(:order_notification).with(order.id)
      .and_call_original
    call

    ActionMailer::Base.deliveries.last.tap do |mail|
      expect(mail).to be_present
      expect(mail.subject).to eq 'New Order'
      expect(mail.to).to eq [order.photographer.email]
    end
  end
end

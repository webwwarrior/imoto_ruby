require 'rails_helper'

describe Resolvers::ContactAdministrator do
  subject(:resolver) { described_class.new }
  let(:object)       { double :object }
  let!(:inputs)      { { 'sender_email' => 'sender@example.com', 'body' => 'Hello Admin', 'subject' => 'Need help' } }
  let(:context)      { double :context }

  context 'successful' do
    specify do
      expect { resolver.call(object, inputs, context) }.not_to raise_error
      expect { resolver.call(object, inputs, context) }.to change(ContactRequest, :count).by(1)
    end
  end

  context 'failure' do
    let(:invalid_input) { inputs.merge('sender_email' => '') }

    specify do
      expect { resolver.call(object, invalid_input, context) }
        .to raise_error("Invalid input for Contact Request: Sender email can't be blank")
    end
  end
end

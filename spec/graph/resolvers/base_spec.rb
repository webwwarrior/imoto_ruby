require 'rails_helper'

describe Resolvers::Base do
  subject(:resolver) { described_class.new }

  let!(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'assets', 'test.jpg')) }

  let(:data1) do
    { 'email'  => 'email@example.com',
      'role'   => 'agent',
      'avatar' => '#!file:customer_avatar' }
  end

  let(:data2) do
    [{ 'id' => '1', 'quantity' => '1', 'document' => '#!file:document' },
     { 'id' => '2', 'quantity' => '25', 'data' => [{ 'key' => 'Room', 'value' => '2' },
                                                   { 'key' => 'Bathroom', 'value' => '3' }] }]
  end

  let(:result1) { { 'email' => 'email@example.com', 'role' => 'agent', 'avatar' => file } }

  let(:result2) do
    [
      { 'id' => '1', 'quantity' => '1', 'document' => file },
      { 'id' => '2', 'quantity' => '25',
        'data' => [{ 'key' => 'Room', 'value' => '2' }, { 'key' => 'Bathroom', 'value' => '3' }] }
    ]
  end

  describe '#formatted_hash' do
    let!(:context1) { { attachments: { 'customer_avatar' => file } } }
    let!(:context2) { { attachments: { 'document' => file } } }

    context 'with file' do
      it { expect(resolver.formatted_hash(data1, context1)).to eq result1 }
      it { expect(resolver.formatted_hash(data2, context2)).to eq result2 }
    end

    context 'without file' do
      let(:context) { { attachments: { 'customer_avatar' => nil } } }
      let(:result)  { result1.merge('avatar' => nil) }

      it { expect(resolver.formatted_hash(data1, context)).to eq result }
    end
  end
end

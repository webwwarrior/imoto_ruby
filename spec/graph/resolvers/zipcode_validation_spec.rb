require 'rails_helper'

describe Resolvers::ZipcodeValidation do
  subject(:resolver) { described_class.new }
  let(:object)       { double :object }
  let!(:inputs)      { { 'value' => '123123', 'state_name' => 'Kansas' } }
  let(:context)      { double :context }
  let!(:zip_code1)   { create :zip_code, value: '123123', state_name: 'Kansas' }
  let!(:zip_code2)   { create :zip_code, value: '888888', state_name: 'Kansas' }

  context 'successful' do
    it { expect(resolver.call(object, inputs, context)).to eq(status: 'valid') }
  end

  context 'failure' do
    let(:invalid_input) { inputs.merge('value' => '44444') }

    specify do
      expect { resolver.call(object, invalid_input, context) }
        .to raise_error('Cannot find zip code 44444 at state Kansas')
    end
  end
end

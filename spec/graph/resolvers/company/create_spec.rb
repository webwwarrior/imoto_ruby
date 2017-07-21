require 'rails_helper'

describe Resolvers::Company::Create do
  subject(:resolver) { described_class.new }

  let(:context)  { { attachments: { 'logo' => file } } }
  let(:object)   { double :object }
  let!(:file)    { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'assets', 'test.jpg')) }

  let!(:inputs) do
    {
      'name'          => 'Test company',
      'office_branch' => 'San Francisco',
      'website'       => 'testcompany.com',
      'logo'          => '#!file:logo',
      'zip_code'      => '23132'
    }
  end

  context 'successful' do
    it { expect { resolver.call(object, inputs, context) }.to change(Company, :count).by(1) }
  end

  context 'failure (not providing name and office_branch)' do
    let!(:inputs) do
      {
        'office_branch' => 'San Francisco',
        'website' => 'testcompany.com'
      }
    end

    specify do
      expect { resolver.call(object, inputs, context) }.not_to change { Company.count }
    end
  end
end

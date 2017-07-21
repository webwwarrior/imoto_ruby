FactoryGirl.define do
  factory :product do
    name        { Faker::Name.name }
    description { Faker::Lorem.sentence }
    sku         { Faker::Code.isbn }
    image       { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'assets', 'test.jpg')) }
    status      :enabled
    category
  end
end

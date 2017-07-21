FactoryGirl.define do
  factory :customer do
    sequence(:email)      { Faker::Internet.email }
    password              '1234567890'
    password_confirmation '1234567890'
    sequence(:full_name)  { Faker::Name.name }
    mobile                { Faker::PhoneNumber.cell_phone }
    website               { Faker::Internet.url }
    second_email          { Faker::Internet.email }
    third_email           { Faker::Internet.email }
    avatar Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/assets/test.jpg')))
    company
  end
end

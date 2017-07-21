FactoryGirl.define do
  factory :company do
    sequence(:name) { Faker::Company.name }
    office_branch   { Faker::Company.suffix }
    website         { Faker::Internet.url }
    logo            'MyString'
    city            { Faker::Address.city }
    state           { Faker::Address.state }
    zip_code        { Faker::Address.zip }
  end
end

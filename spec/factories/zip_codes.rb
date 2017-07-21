FactoryGirl.define do
  factory :zip_code do
    sequence(:value) { Faker::Address.zip_code }
    state_code       { Faker::Address.state_abbr }
    state_name       { Faker::Address.state }
    city             { Faker::Address.city }
    time_zone        { Faker::Address.time_zone }
  end
end

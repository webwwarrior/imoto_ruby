FactoryGirl.define do
  factory :admin do
    first_name            Faker::Name.first_name
    last_name             Faker::Name.last_name
    sequence(:email)      { Faker::Internet.email }
    password              '1234567890'
    password_confirmation '1234567890'
  end
end

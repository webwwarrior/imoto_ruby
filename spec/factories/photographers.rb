FactoryGirl.define do
  factory :photographer do
    sequence(:email)      { Faker::Internet.email }
    password              '1234567890'
    password_confirmation '1234567890'
    avatar                'MyString'
    first_name            { Faker::Name.name }
    last_name             { Faker::Name.name }
    zip_codes             { [FactoryGirl.create(:zip_code)] }
    default_time_zone     { Faker::Address.time_zone }
  end
end

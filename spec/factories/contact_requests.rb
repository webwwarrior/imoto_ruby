FactoryGirl.define do
  factory :contact_request do
    sender_email { Faker::Internet.email }
    body         { Faker::Lorem.sentence }
    subject      { Faker::Lorem.word }
  end
end

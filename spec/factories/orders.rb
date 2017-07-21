FactoryGirl.define do
  factory :order do
    status              :pending
    address             { Faker::Address.street_address }
    second_address      { Faker::Address.secondary_address }
    city                { Faker::Address.city }
    state               { Faker::Address.state }
    zip_code            { Faker::Address.zip_code }
    listing_price       { Faker::Number.decimal(2) }
    square_footage      { Faker::Number.decimal(2) }
    number_of_beds      { Faker::Number.decimal(2) }
    number_of_baths     { Faker::Number.decimal(2) }
    listing_description { Faker::Lorem.sentence }
    additional_notes    { Faker::Lorem.word }
    customer
    coupon
  end
end

FactoryGirl.define do
  factory :credit_card do
    auth_code      { Faker::Number.number(2) }
    trans_id       { Faker::Number.number(2) }
    account_number { Faker::Number.number(2) }
    account_type   'Visa'
    customer
  end
end

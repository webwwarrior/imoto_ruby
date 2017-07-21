FactoryGirl.define do
  factory :order_attribute do
    order
    quantity { Faker::Number.number(2) }
    price    { Faker::Number.decimal(2) }
    name     { Faker::Name.name }
  end
end

FactoryGirl.define do
  factory :orders_product do
    quantity { Faker::Number.digit }
    order
    product
  end
end

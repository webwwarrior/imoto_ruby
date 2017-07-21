FactoryGirl.define do
  factory :coupon do
    sequence(:name)     { Faker::Company.name }
    sequence(:code)     { Faker::Code.asin }
    max_uses_per_user   { Faker::Number.number(2) }
    start_date          { Faker::Date.between(2.days.ago, Date.current) }
    expiration_date     { Faker::Date.between(Date.current + 2.days, Date.current + 6.days) }
    minimum_purchase    { Faker::Number.decimal(2) }
    discount_type       :percentage
    discount_amount     { Faker::Number.decimal(2) }
    status              :enabled
    max_uses            { Faker::Number.number(2) }
    track_coupon_usage  0
    company
  end
end

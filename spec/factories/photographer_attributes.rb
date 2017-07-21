FactoryGirl.define do
  factory :photographer_attribute do
    photographer
    attribute_item
    default_time    Faker::Number.between(1, 10)
    extra_time      { Faker::Number.digit }
    rate            { Faker::Number.decimal(2) }
    additional_rate { Faker::Number.decimal(2) }
  end
end

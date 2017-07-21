FactoryGirl.define do
  factory :calendar_item do
    photographer
    unavailable_from         { Faker::Time.between(DateTime.current - 1, DateTime.current) }
    unavailable_to           { Faker::Time.between(DateTime.current + 1, DateTime.current + 2) }
    google_calendar_event_id { Faker::Number.unique.digit }
    description              { Faker::Lorem.sentence }
    title                    { Faker::Name.title }
  end
end

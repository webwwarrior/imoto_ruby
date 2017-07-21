module Mutations::Photographer
  CreateCalendarItems = GraphQL::Relay::Mutation.define do
    name 'CreateCalendarItems'
    description 'Add new items to photographers calendar'

    input_field :calendar_items, !types[CalendarItemInput]

    return_field :calendar_items, types[CalendarItemType]

    resolve Resolvers::Photographer::CreateCalendarItems.new
  end
end

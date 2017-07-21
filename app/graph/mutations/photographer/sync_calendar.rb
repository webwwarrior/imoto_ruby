module Mutations::Photographer
  SyncCalendar = GraphQL::Relay::Mutation.define do
    name 'SyncCalendar'
    description 'Sync imoto calendar with google calendar'

    input_field :access_token, !types.String
    input_field :expires_at,   !types.Int

    return_field :calendar_items, types[CalendarItemType]

    resolve Resolvers::Photographer::SyncCalendar.new
  end
end

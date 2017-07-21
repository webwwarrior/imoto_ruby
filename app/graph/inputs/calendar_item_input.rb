CalendarItemInput = GraphQL::InputObjectType.define do
  name 'CalendarItemInput'
  description 'Calendar Item Information'

  argument :unavailable_from,            !types.String
  argument :unavailable_to,              !types.String
  argument :title,                       !types.String
  argument :description,                 types.String
  argument :google_calendar_event_id,    types.String
  argument :kind,                        types.String
  argument :internal,                    types.Boolean
end

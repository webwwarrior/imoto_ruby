module Resolvers::Photographer
  class SyncCalendar < Resolvers::Base
    # rubocop:disable all
    def call(_object, inputs, context)
      photographer = context[:current_user]
      raise GraphQL::ExecutionError.new('You need to sign in or sign up before continuing') unless photographer.is_a?(::Photographer)

      photographer.assign_attributes(google_access_token: inputs.to_h['access_token'],
                                     google_expires_at: inputs.to_h['expires_at'])

      unless photographer.save
        raise GraphQL::ExecutionError.new("Invalid input for CalendarItem: #{@photographer.errors.full_messages.join(', ')}")
      end

      google_calendar = GoogleCalendar.new(photographer)

      google_calendar.import_events
      
      photographer.orders.each do |order|
        google_calendar.export_event(order)
      end

      { calendar_items: photographer.calendar_items }
    rescue ArgumentError
      raise GraphQL::ExecutionError.new("Invalid input for CalendarItem: Kind should be one of the following values: #{CalendarItem.kinds.keys.join(", ")}")
    end
    #rubocop:enable all
  end
end

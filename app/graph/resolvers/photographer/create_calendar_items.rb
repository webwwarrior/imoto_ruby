module Resolvers::Photographer
  class CreateCalendarItems < Resolvers::Base
    # rubocop:disable all
    def call(_object, inputs, context)
      photographer = context[:current_user]
      raise GraphQL::ExecutionError.new('You need to sign in or sign up before continuing') unless photographer.is_a?(::Photographer)

      calendar_items = photographer.calendar_items.build(inputs.to_h['calendar_items'])

      unless photographer.save
        raise GraphQL::ExecutionError.new("Invalid input for CalendarItem: #{@photographer.errors.full_messages.join(', ')}")
      end

      { calendar_items: calendar_items }
    rescue ArgumentError
      raise GraphQL::ExecutionError.new("Invalid input for CalendarItem: Kind should be one of the following values: #{CalendarItem.kinds.keys.join(", ")}")
    end
    #rubocop:enable all
  end
end

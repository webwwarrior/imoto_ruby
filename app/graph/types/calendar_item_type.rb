CalendarItemType = GraphQL::ObjectType.define do
  name 'CalendarItem'
  description 'Calendar item information'

  # Expose fields from the model
  field :id,                          !types.ID
  field :photographer_id,             !types.ID
  field :title,                       !types.String
  field :description,                 types.String
  field :google_calendar_event_id,    types.String
  field :kind,                        types.String
  field :internal,                    types.Boolean

  field :unavailable_from, !types.String do
    resolve ->(obj, _args, _ctx) do
      obj.unavailable_from.to_datetime.rfc3339
    end
  end

  field :unavailable_to, !types.String do
    resolve ->(obj, _args, _ctx) do
      obj.unavailable_to.to_datetime.rfc3339
    end
  end

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end

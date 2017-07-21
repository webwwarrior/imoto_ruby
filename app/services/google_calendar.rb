require 'google/apis/calendar_v3'

class GoogleCalendar
  SERVICE = Google::Apis::CalendarV3.freeze

  def initialize(user, order = nil)
    @user = user
    @order = order
    @service = SERVICE::CalendarService.new
    @service.authorization = @user.google_token
    @calendar = find_or_initialize_calendar
    # initialize_webhooks if @user.google_resource_id.nil?
  end

  def import_events
    events.each { |event| create_or_initialize_calendar_item(event) }
  end

  # create an event on google calendar
  def export_event(order = nil)
    @order = order

    if @order && events.all? { |event| event.id != @order.calendar_item.google_calendar_event_id }
      event = @service.insert_event(@calendar.id, new_event, send_notifications: true)

      if @order.calendar_item
        @order.calendar_item.update(
          google_calendar_event_id: event.id
        )
      else
        @user.calendar_items.create(
          google_calendar_event_id: event.id,
          unavailable_from:         event.start.date_time,
          unavailable_to:           event.end.date_time,
          description:              event.summary,
          internal:                 true
        )
      end
    end
  end

  private

  def create_or_initialize_calendar_item(event)
    calendar_item = @user.calendar_items.find_or_initialize_by(google_calendar_event_id: event.id)
    return if calendar_item.persisted?

    calendar_item.update_attributes(
      unavailable_from:         event.start.date.to_time,
      unavailable_to:           event.end.date.to_time,
      title:                    event.summary,
      description:              event.description,
      internal:                 false
    )
  end

  def events
    @events = @service.list_events(
      @calendar.id,
      time_min: format_date(DateTime.current),
      time_max: format_date(DateTime.current + 1.month)
    ).items
  end

  def time_zone
    @time_zone ||= @user.default_time_zone
  end

  # rubocop:disable all
  def new_event
    SERVICE::Event.new(
      summary:     @order.full_address,
      description: @order.listing_description,
      start: {
        date_time: format_date(@order.event_started_at),
        time_zone: time_zone
      },
      end: {
        date_time: format_date(@order.execution_time),
        time_zone: time_zone
      }
    )
  end
  # rubocop:enable all

  def new_calendar
    SERVICE::Calendar.new(
      summary: Rails.application.secrets['google_calendar_name'],
      time_zone: time_zone
    )
  end

  def find_or_initialize_calendar
    @service.list_calendar_lists.items.find do |calendar|
      calendar.summary == Rails.application.secrets['google_calendar_name']
    end || @service.insert_calendar(new_calendar)
  end

  def format_date(date_time)
    date_time.in_time_zone(time_zone).strftime('%Y-%m-%dT%H:%M:%S%z')
  end

  def initialize_webhooks
    channel = SERVICE::Channel.new(address: Rails.application.secrets['google_webhook_url'], id: @user.uid,
                                   type: 'web_hook')

    webhook = @service.watch_event(
      @calendar.id, channel, single_events: true, time_min: Time.now.to_datetime.rfc3339
    )

    @user.update(google_resource_id: webhook.resource_id)
  end
end

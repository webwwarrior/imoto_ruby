class Photographer::GoogleEventsSynchronizer
  include Sidekiq::Worker

  def perform(photographer_id)
    ::GoogleCalendar.new(Photographer.find(photographer_id)).import_events
  end
end

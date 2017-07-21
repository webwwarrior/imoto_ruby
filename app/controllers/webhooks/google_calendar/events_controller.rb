class Webhooks::GoogleCalendar::EventsController < Webhooks::BaseController
  def create
    Photographer::GoogleEventsSynchronizer.perform_in(5.seconds, photographer.id)
    head :ok
  end

  private

  def photographer
    @photographer ||= Photographer.find_by(google_resource_id: request.headers['HTTP_X_GOOG_RESOURCE_ID'])
  end
end

class Photographer::OrderNotification
  include Sidekiq::Worker

  def perform(order_id)
    PhotographerMailer.order_notification(order_id).deliver_now
  end
end

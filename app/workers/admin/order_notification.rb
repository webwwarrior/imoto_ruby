class Admin::OrderNotification
  include Sidekiq::Worker

  def perform(order_id)
    AdminMailer.order_notification(order_id).deliver_now
  end
end

class PhotographerMailer < ApplicationMailer
  def send_password(photographer_id, password)
    @photographer = Photographer.find(photographer_id)
    @password = password
    mail(subject: 'Your password for imoto', to: @photographer.email)
  end

  def order_notification(order_id)
    @order = Order.find(order_id)
    mail(subject: 'New Order', to: @order.photographer.email)
  end
end

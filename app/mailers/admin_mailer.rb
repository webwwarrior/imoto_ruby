class AdminMailer < ApplicationMailer
  def contact_request(sender_email, body, subject)
    @sender_email = sender_email
    @body = body
    mail(subject: subject, to: Admin.pluck(:email))
  end

  def order_notification(order_id)
    @order = Order.find(order_id)
    mail(subject: 'New Order', to: Admin.pluck(:email))
  end
end

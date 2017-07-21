class Admin::HelpRequest
  include Sidekiq::Worker

  def perform(sender_email, body, subject)
    AdminMailer.contact_request(sender_email, body, subject).deliver_now
  end
end

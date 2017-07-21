class Photographer::SendPassword
  include Sidekiq::Worker

  def perform(photographer_id, password)
    PhotographerMailer.send_password(photographer_id, password).deliver_now
  end
end

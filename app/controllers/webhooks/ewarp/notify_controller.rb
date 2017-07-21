class  Webhooks::Ewarp::NotifyController < Webhooks::BaseController
 def index
   Rails.logger.info("PARAMS: #{params.inspect}")
   log = Logger.new('log/ewarp_notify.log')
   log.info("PARAMS: #{params.inspect}")
   head :ok
 end
end
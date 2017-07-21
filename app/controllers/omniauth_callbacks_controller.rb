class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env['omniauth.auth']
    photographer = OauthAuthenticator.new(auth).photographer

    redirect_to_confirmation_path(photographer) if photographer.present?
  end

  private

  def redirect_to_confirmation_path(photographer)
    web_client = Rails.application.config.web_client
    redirect_to web_client['host'] + web_client['after_confirmation_path'].gsub(':id', photographer.id.to_s)
  end
end

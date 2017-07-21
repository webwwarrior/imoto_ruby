class OauthAuthenticator
  # rubocop:disable all
  def initialize(auth_data)
    @auth_data = {
      uid:                  auth_data['uid'],
      provider:             auth_data['provider'],
      email:                auth_data['info']['email'],
      first_name:           auth_data['info']['first_name'],
      last_name:            auth_data['info']['last_name'],
      google_access_token:  auth_data['credentials']['token'],
      google_refresh_token: auth_data['credentials']['refresh_token'],
      google_expires_at:    auth_data['credentials']['expires_at'],
      password:             Devise.friendly_token[0, 20]
    }
  end
  # rubocop:enable all

  def photographer
    photograher = Photographer.find_or_initialize_by(email: @auth_data[:email])
    photograher.assign_attributes(@auth_data)
    return nil unless photograher.save
    photograher
  end
end

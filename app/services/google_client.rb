class GoogleClient
  def initialize(user)
    @user = user
  end

  def refresh_token!
    data = JSON.parse(request_token_from_google.body)
    @user.update(
      google_access_token: data['access_token'], google_expires_at: (Time.current.to_i + data['expires_in'].to_i)
    )
    @user.google_access_token
  end

  private

  def to_params
    { 'refresh_token' => @user.google_refresh_token,
      'client_id'     => Rails.application.secrets['google_client_id'],
      'client_secret' => Rails.application.secrets['google_client_secret'],
      'grant_type'    => 'refresh_token' }
  end

  def request_token_from_google
    url = URI('https://accounts.google.com/o/oauth2/token')
    Net::HTTP.post_form(url, to_params)
  end
end

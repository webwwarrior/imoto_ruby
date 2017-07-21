# should be reworked, it's only a hack for demo
Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = {
    value:    user.id,
    expires:  1.month.from_now,
    domain:   Rails.application.secrets[:cookie_domain],
    httponly: true
  }
end

Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = {
    value:    nil,
    expires:  Time.at(0),
    domain:   Rails.application.secrets[:cookie_domain],
    httponly: true
  }
end

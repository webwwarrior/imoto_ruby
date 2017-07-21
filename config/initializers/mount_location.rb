if Rails.env.production?
  Imoto::Application.config.relative_url_root = "/api"
end

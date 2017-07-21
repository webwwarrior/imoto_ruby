require 'sidekiq'

Sidekiq.hook_rails!

redis_opts = {
  url:       ENV['REDIS_URL'] || 'redis://127.0.0.1:6379/0',
  namespace: 'imoto_api_#{Rails.env}'
}
if Rails.env.test?
  require 'fakeredis'
  redis_opts[:driver] = Redis::Connection::Memory
end

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end

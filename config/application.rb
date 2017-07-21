require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Imoto
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('app', 'graph', 'types')
    config.autoload_paths << Rails.root.join('app', 'graph', 'resolvers')
    config.autoload_paths << Rails.root.join('app', 'graph', 'inputs')
    config.autoload_paths << Rails.root.join('app', 'lib')
    config.autoload_paths << Rails.root.join('app', 'workers')
    config.autoload_paths << Rails.root.join('lib')
    config.active_record.time_zone_aware_types = [:datetime]
    config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end
    config.web_client = config_for(:web_client)
  end
end

source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'sass-rails', '~> 5.0'
gem 'haml-rails'
gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-es6'
gem 'pg'
gem 'figaro'
gem 'graphql'
gem 'graphiql-rails'
gem 'devise'
gem 'sidekiq'
gem 'rack-cors', require: 'rack/cors'
# To upload files to Amazon 3S using gem fog-aws. It does not upload files in case of stable version of carrierwave
gem 'carrierwave',  git: 'https://github.com/carrierwaveuploader/carrierwave.git'
# Due to version conflict
gem 'administrate', git: 'https://github.com/thoughtbot/administrate', ref: '84096ca0b90c91f3033d123ad4c2ff691123e73a'
gem 'administrate-field-password'
gem 'bourbon'
gem 'fog-aws'
gem 'sentry-raven'
gem 'rails_12factor', group: [:staging, :production]
gem 'select2-rails'
gem 'ruby-progressbar'
gem 'omniauth-google-oauth2'
gem 'google-api-client'
gem 'httparty'
gem 'redis-namespace'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'fuubar'
  gem 'jazz_fingers'
  gem 'mina', require: false
  gem 'mina-puma', require: false, github: 'untitledkingdom/mina-puma'
  gem 'mina-sidekiq', require: false
end

group :development do
  gem 'web-console'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
  gem 'annotate'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'fakeredis', require: 'fakeredis/rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'listen', '~> 3.0.5'

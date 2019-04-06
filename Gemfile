source 'https://rubygems.org'

ruby '2.6.1'

gem 'rails', '~> 5.2', '>= 5.2.2.1'
gem 'puma'
gem 'pg'
gem 'activerecord-postgis-adapter', '~> 5.0'
gem 'rgeo'
gem 'rgeo-geojson'
gem 'sucker_punch'

gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-rewrite'

gem 'aasm'
gem 'acts-as-taggable-on'
gem 'browser'
gem 'cocoon'
gem 'devise'
gem 'friendly_id'
gem 'httparty'
gem 'jbuilder'
gem 'kaminari'
gem 'remotipart'
gem 'sitemap_generator'
gem 'google_custom_search_api'

gem 'mandrill-api', '~> 1.0.53', require: "mandrill"
gem 'gibbon', '~> 3.0', '>= 3.0.2'
gem 'newrelic_rpm'
# gem 'rollbar'
gem "bugsnag"
gem 'scout_apm'

gem 'refile', github: 'refile/refile', require: 'refile/rails'
gem 'refile-mini_magick', github: 'refile/refile-mini_magick'
gem 'sinatra', github: 'sinatra/sinatra'
gem 'refile-s3'

gem 'sass-rails'
gem 'uglifier'
gem 'mini_racer', platforms: :ruby
gem 'jquery-rails'
gem 'underscore-rails'
gem 'autoprefixer-rails'

gem 'activeadmin'
gem 'rabl'
gem 'oj'
gem 'jquery-ui-rails', '6.0.0'
gem 'bb-ruby'
gem 'stripe'

group :development do
  gem 'spring'
  gem 'letter_opener'
end

group :development, :test do
  gem 'listen', '~> 3.0.5'
  # Helpers don't work if required, https://github.com/rspec/rspec-rails/issues/1525
  gem 'rails-controller-testing', require: false
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'guard-livereload'
  gem 'foreman', require: false
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

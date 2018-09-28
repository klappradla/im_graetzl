source 'https://rubygems.org'

ruby '2.3.4'

gem 'rails', '~> 5.0'
gem 'puma'
gem 'pg'
gem 'activerecord-postgis-adapter', '~> 4.0'
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

gem 'mandrill-api', '~> 1.0.53', require: "mandrill"
gem 'gibbon', '~> 3.0', '>= 3.0.2'
gem 'newrelic_rpm'
gem 'rollbar'
gem 'scout_apm'

gem 'refile', github: 'refile/refile', require: 'refile/rails'
gem 'refile-mini_magick', github: 'refile/refile-mini_magick'
gem 'sinatra', github: 'sinatra/sinatra', ref: "88a1ba7bfb2262b68391d2490dbb440184b9f838"
gem 'refile-s3'
gem 'aws-sdk', '~> 2.7'

gem 'sass-rails'
gem 'uglifier'
gem 'therubyracer',  platforms: :ruby
gem 'jquery-rails'
gem 'underscore-rails'
gem 'autoprefixer-rails'

gem 'activeadmin', '~> 1.0.0.pre4'
gem 'rabl'
gem 'oj'
gem 'jquery-ui-rails', '5.0.0'
gem 'google_custom_search_api'

group :doc do
  gem 'sdoc'
end

group :development do
  gem 'spring'
  gem 'letter_opener'
end

group :development, :test do
  gem 'listen', '~> 3.0.5'
  # Helpers don't work if required, https://github.com/rspec/rspec-rails/issues/1525
  gem 'rails-controller-testing', require: false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'guard-livereload'
  gem 'foreman', require: false
end

group :development, :test, :staging do
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

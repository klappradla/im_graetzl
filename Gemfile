source 'https://rubygems.org'

ruby '2.7.2'

gem 'rails', '~> 5.2'
gem 'puma'
gem 'puma_worker_killer'
gem 'pg'
gem 'activerecord-postgis-adapter', '~> 5.0'
gem 'rgeo'
gem 'rgeo-geojson'
gem 'delayed_job_active_record'

gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-rewrite'

gem 'aasm'
gem 'acts-as-taggable-on'
gem 'aws-sdk', '~> 2.0'
gem 'browser'
gem 'cocoon'
gem 'devise'
gem 'friendly_id'
gem 'httparty'
gem 'jbuilder'
gem 'kaminari'
gem 'remotipart'
gem 'sitemap_generator'
gem 'prawn'
gem 'prawn-table'
gem 'google_custom_search_api'

gem 'gibbon', '~> 3.0', '>= 3.0.2'
gem 'newrelic_rpm'
gem 'rollbar'
gem 'scout_apm'

# Refile is pretty much abandoned and we have to jump through hoops to make it work
# It should be replaced with active-storage or shrine in the next upgrade
gem 'refile', github: 'refile/refile', require: 'refile/rails', ref: '6803d83f0764558932de6880728672326211b018'
gem 'refile-mini_magick', github: 'refile/refile-mini_magick', ref: '466e30cf5878844b0e0bc4588f766bb18dabdd2b'
gem 'sinatra', github: 'sinatra/sinatra', ref: '6f15fba2790ebdf4d1215cebf425dea2ea3130ea'
gem 'refile-s3'

# Lib V8does not support Macbook M1 for the moment, so for development on M1, use the commented gem
# Just make sure to comment it back and run bundle install before commiting changes
gem 'mini_racer' # For deployment
#gem 'mini_racer', github: 'rubyjs/mini_racer', branch: 'refs/pull/186/head' # For M1

gem 'sass-rails'
gem 'uglifier'
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

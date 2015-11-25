source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

# instead of rails, use only rails-api and friends
# this will change when rails 5 is out, since rails-api will be included in rails
gem 'bundler'
gem 'activerecord'
gem 'actionmailer'
gem 'activesupport'
gem 'rails-api'
gem 'active_model_serializers'

gem 'pg'
gem 'figaro'
gem 'rails-i18n'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-timeout'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'brakeman', require: false
end

group :development, :test do
  gem 'rubocop'
  gem 'byebug'
  gem 'quiet_assets'
  gem 'faker'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'sentry-raven'
  gem 'newrelic_rpm'
  gem 'lograge'
end

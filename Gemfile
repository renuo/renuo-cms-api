source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'pg'

gem 'figaro'
gem 'rails-i18n'
gem 'devise'
gem 'devise-i18n'
gem 'paperclip'
gem 'uglifier'
gem 'rack-cors', require: 'rack/cors'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rubocop'
  gem 'byebug'
  gem 'quiet_assets'
  gem 'faker'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'sentry-raven'
  gem 'newrelic_rpm'
end

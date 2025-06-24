source "https://rubygems.org"

ruby '3.2.8'

# Specify your gem's dependencies in reportable_rails.gemspec
gemspec

gem "active_model_serializers"

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "simplecov", require: false
  gem "database_cleaner-active_record"
  gem 'guard'
  gem "guard-rspec", require: false
end

# Add gems needed for development but not required by the gem itself
group :development do
  gem "rake"
  gem "bundler"
end

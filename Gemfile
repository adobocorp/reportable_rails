source "https://rubygems.org"

# Specify your gem's dependencies in reportable_rails.gemspec
gemspec

# Runtime dependencies
gem "rails", ">= 6.1"
gem "active_model_serializers"

group :development, :test do
  gem "sqlite3"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

# Add gems needed for development but not required by the gem itself
group :development do
  gem "rake"
  gem "bundler"
end

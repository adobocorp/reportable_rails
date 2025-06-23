require 'bundler/setup'
require 'reportable_rails'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    # Ensure schema is loaded into in-memory database
    ActiveRecord::Schema.verbose = false
    load File.expand_path('dummy/db/schema.rb', __dir__)
  end
end

ENV['RAILS_ENV'] = 'test'
require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'
require 'reportable_rails'

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('..', __dir__)
    config.cache_classes = true
    config.eager_load = false
    config.public_file_server.enabled = true
    config.cache_store = :null_store
    config.consider_all_requests_local = true
    config.action_controller.perform_caching = false
    config.action_dispatch.show_exceptions = false
    config.action_controller.allow_forgery_protection = false
    config.active_support.deprecation = :stderr
    config.active_support.test_order = :random
  end
end

Dummy::Application.initialize!

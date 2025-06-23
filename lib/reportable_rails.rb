# frozen_string_literal: true

require 'rails/engine'
require 'active_model_serializers'
require 'reportable_rails/version'

module ReportableRails
  class Error < StandardError; end
  
  class Engine < ::Rails::Engine
    isolate_namespace ReportableRails
    
    initializer 'reportable_rails.initialize' do |app|
      # Add any initialization code here
    end
    
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
  
  # Configuration
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :user_class, :default_category_name
    
    def initialize
      @user_class = 'User'
      @default_category_name = 'Uncategorized'
    end
  end
end

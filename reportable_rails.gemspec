lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reportable_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "reportable_rails"
  spec.version       = ReportableRails::VERSION
  spec.authors       = ["Nicu Listana"]
  spec.email         = ["nicu@adoboenterprisesus.com"]

  spec.summary       = %q{A Rails engine for handling user reports and hours logging}
  spec.description   = %q{ReportableRails provides a complete solution for managing user reports, hours logging, and report categories in Ruby on Rails applications}
  spec.homepage      = "https://github.com/adobocorp/reportable_rails"
  spec.license       = "MIT"

  spec.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  
  spec.add_dependency "rails", ">= 6.1"
  spec.add_dependency "active_model_serializers"
  spec.add_dependency "actionview", ">= 6.1.0"
  spec.add_dependency "activerecord", ">= 6.1.0"
  spec.add_dependency "activemodel", ">= 6.1.0"
  spec.add_dependency "activesupport", ">= 6.1.0"
  spec.add_dependency "tzinfo-data", "~> 1.2023"
  spec.add_dependency "sqlite3"
  
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "shoulda-matchers", "~> 5.0"
end

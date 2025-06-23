Rails.application.config.after_initialize do
  require_relative "../../app/models/application_record"

  # Ensure ReportableRails is configured first
  ReportableRails.configure do |config|
    config.user_class = 'User'
    config.default_category_name = 'General'
    config.report_submitted_callback = ->(report) { }
  end

  # Then load all models from the dummy app
  Dir[File.expand_path("../../app/models/**/*.rb", __dir__)].sort.each do |file|
    require file unless file.include?("application_record.rb")
  end
end

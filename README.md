# ReportableRails

ReportableRails is a Ruby on Rails gem that provides a flexible reporting system for tracking and managing time-based reports with period management.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reportable_rails'
```

And then execute:

```bash
$ bundle install
```

## Configuration

ReportableRails can be configured in an initializer:

```ruby
# config/initializers/reportable_rails.rb
ReportableRails.configure do |config|
  # Set the user class for report ownership (default: 'User')
  config.user_class = 'User'

  # Configure a callback for when reports are submitted
  config.report_submitted_callback = ->(report) {
    # Your custom logic here
    # For example: NotificationMailer.report_submitted(report).deliver_later
  }
end
```

## Usage

### Setting Up Models

Include the Report module in your model:

```ruby
class TimeReport < ApplicationRecord
  include ReportableRails::Models::Report
end
```

This will add the following associations and functionality to your model:
- `belongs_to :owner` (user who owns the report)
- `belongs_to :report_category` (optional categorization)
- `has_many :hours_logs` (time entries for the report)

### Managing Hours Logs

```ruby
# Add hours to a report
report.add_hours_log({
  hours: 8,
  date: Date.current,
  description: 'Project work'
})

# Remove hours from a report
report.remove_hours_log(hours_log_id)
```

### Period Management

The gem includes built-in period management with bi-monthly periods (1st-15th and 16th-end of month):

```ruby
# Get current period dates
start_date = report.current_period_start_date
end_date = report.current_period_end_date

# Get hours for current period
current_hours = report.current_period_hours

# Submit current period report
report.submit_current_period_report!
```

### Report Categories

Reports can be optionally categorized:

```ruby
report = TimeReport.create!(
  owner: current_user,
  report_category: ReportableRails::ReportCategory.find_by(name: 'Project Work')
)
```

## License

The gem is available as open source under the terms of the MIT License.

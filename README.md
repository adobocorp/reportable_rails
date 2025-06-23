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

  # Customize the name of the default category
  config.default_category_name = 'General' # Defaults to 'Uncategorized'
end
```

## Usage

### Setting Up Models

ReportableRails provides three main models that can be included in your application:

```ruby
# app/models/time_report.rb
class TimeReport < ApplicationRecord
  include ReportableRails::Models::Report
end

# app/models/report_category.rb
class ReportCategory < ApplicationRecord
  include ReportableRails::Models::ReportCategory
end

# app/models/hours_log.rb
class HoursLog < ApplicationRecord
  include ReportableRails::Models::HoursLog
end
```

Each model provides the following functionality:

#### Report Model
- `belongs_to :owner` (user who owns the report)
- `belongs_to :report_category` (optional categorization)
- `has_many :hours_logs` (time entries for the report)
- Period management methods
- Report submission handling

#### Report Category Model
- `has_many :reports`
- Name and description tracking
- Active/inactive status management
- Scopes for filtering active categories
- Helper methods for finding and managing categories

#### Hours Log Model
- `belongs_to :report`
- Hours and date tracking
- Period validation
- Description management
- Methods for checking if hours are in current period

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

### Default Category

ReportableRails automatically manages a default "Uncategorized" category that cannot be deactivated or deleted. You can customize the name of this category in your configuration:

```ruby
ReportableRails.configure do |config|
  config.default_category_name = 'General' # Defaults to 'Uncategorized'
end
```

To access the default category:

```ruby
default_category = ReportCategory.default_category # Returns or creates the default category
```

Reports without a specific category will use this default category. The default category:
- Cannot be deactivated
- Cannot be deleted
- Is automatically created when first accessed

### Database Setup

You'll need to create the necessary database tables. Here are the recommended migrations:

```ruby
# Create Reports Table
class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :report_category, foreign_key: true
      t.timestamps
    end
  end
end

# Create Report Categories Table
class CreateReportCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :report_categories do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true
      t.timestamps
      t.index :name, unique: true
    end
  end
end

# Create Hours Logs Table
class CreateHoursLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :hours_logs do |t|
      t.references :report, null: false, foreign_key: true
      t.decimal :hours, null: false, precision: 4, scale: 2
      t.date :date, null: false
      t.text :description, null: false
      t.timestamps
      t.index [:report_id, :date]
    end
  end
end
```

Run the migrations with:

```bash
$ rails db:migrate
```

## License

The gem is available as open source under the terms of the MIT License.

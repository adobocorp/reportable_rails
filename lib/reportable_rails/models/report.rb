module ReportableRails
  module Models
    module Report
      extend ActiveSupport::Concern

      included do
        belongs_to :owner, class_name: ReportableRails.configuration.user_class
        belongs_to :report_category, optional: true
        has_many :hours_logs, dependent: :destroy

        validates :owner, presence: true

        def add_hours_log(hours_log_params)
          validate_period_for_date(hours_log_params[:date])
          hours_logs.create(hours_log_params)
        end

        def remove_hours_log(hours_log_id)
          hours_logs.find_by(id: hours_log_id)&.destroy
        end

        def current_period_start_date
          if Date.current.day <= 15
            Date.current.beginning_of_month
          else
            Date.current.beginning_of_month + 15.days
          end
        end

        def current_period_end_date
          if Date.current.day <= 15
            Date.current.beginning_of_month + 14.days
          else
            Date.current.end_of_month
          end
        end

        def submit_current_period_report!
          return false if current_period_hours.empty?
          
          ReportableRails.configuration.report_submitted_callback&.call(self)
          true
        rescue StandardError => e
          Rails.logger.error("Failed to submit current period report: #{e.message}")
          false
        end

        def current_period_hours
          hours_logs.select(&:current_period?)
        end

        private

        def validate_period_for_date(date)
          return if date.nil?
          
          unless date >= current_period_start_date && date <= current_period_end_date
            raise InvalidPeriodError, "Date must be within the current reporting period (#{current_period_start_date} to #{current_period_end_date})"
          end
        end

      end
    end
  end
end

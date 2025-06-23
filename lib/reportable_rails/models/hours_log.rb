module ReportableRails
  module Models
    module HoursLog
      extend ActiveSupport::Concern

      included do
        belongs_to :report

        validates :hours, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 24 }
        validates :date, presence: true
        validates :description, presence: true, length: { maximum: 1000 }

        validate :date_within_period

        # Check if the hours log belongs to the current reporting period
        def current_period?
          return false unless report && date

          date >= report.current_period_start_date && date <= report.current_period_end_date
        end

        private

        def date_within_period
          return unless date && report

          unless date >= report.current_period_start_date && date <= report.current_period_end_date
            errors.add(:date, "must be within the current reporting period (#{report.current_period_start_date} to #{report.current_period_end_date})")
          end
        end
      end
    end
  end
end

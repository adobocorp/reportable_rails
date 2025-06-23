require 'rails_helper'

RSpec.describe Report do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:report)).to be_valid
    end

    it 'creates associated report category' do
      report = create(:report)
      expect(report.report_category).to be_present
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to belong_to(:report_category).optional }
    it { is_expected.to have_many(:hours_logs).dependent(:destroy) }
  end
  describe '#add_hours_log' do
    let(:report) { create(:report) }
    let(:current_date) { Date.new(2025, 6, 10) }
    let(:valid_params) do
      {
        hours: 8,
        date: current_date,
        description: 'Development work'
      }
    end

    before do
      allow(Date).to receive(:current).and_return(current_date)
    end

    it 'creates a new hours log' do
      expect {
        report.add_hours_log(valid_params)
      }.to change(report.hours_logs, :count).by(1)
    end

    it 'sets the correct attributes' do
      hours_log = report.add_hours_log(valid_params)
      expect(hours_log).to have_attributes(
        hours: 8,
        date: Date.current,
        description: 'Development work'
      )
    end
  end

  describe '#remove_hours_log' do
    let(:report) { create(:report) }
    let!(:hours_log) { create(:hours_log, report: report) }

    it 'removes the specified hours log' do
      expect {
        report.remove_hours_log(hours_log.id)
      }.to change(report.hours_logs, :count).by(-1)
    end

    it 'returns nil for non-existent hours log' do
      expect(report.remove_hours_log(-1)).to be_nil
    end
  end

  describe 'period management' do
    let(:report) { create(:report) }
    let(:current_date) { Date.new(2025, 6, 10) } # First period of June
    
    before do
      allow(Date).to receive(:current).and_return(current_date)
    end

    describe '#add_hours_log' do
      context 'when in first half of month (1st-15th)' do
        let(:current_date) { Date.new(2025, 6, 10) }

        it 'raises error when adding hours for second half of month' do
          expect {
            report.add_hours_log(
              hours: 8,
              date: Date.new(2025, 6, 16),
              description: 'Future work'
            )
          }.to raise_error(ReportableRails::InvalidPeriodError, /must be within the current reporting period/)
        end

        it 'raises error when adding hours from previous month' do
          expect {
            report.add_hours_log(
              hours: 8,
              date: Date.new(2025, 5, 10),
              description: 'Past work'
            )
          }.to raise_error(ReportableRails::InvalidPeriodError, /must be within the current reporting period/)
        end
      end

      context 'when in second half of month (16th-end)' do
        let(:current_date) { Date.new(2025, 6, 20) }

        it 'raises error when adding hours for first half of month' do
          expect {
            report.add_hours_log(
              hours: 8,
              date: Date.new(2025, 6, 14),
              description: 'Past work'
            )
          }.to raise_error(ReportableRails::InvalidPeriodError, /must be within the current reporting period/)
        end

        it 'raises error when adding hours for next month' do
          expect {
            report.add_hours_log(
              hours: 8,
              date: Date.new(2025, 7, 1),
              description: 'Future work'
            )
          }.to raise_error(ReportableRails::InvalidPeriodError, /must be within the current reporting period/)
        end
      end
    end
  end
  describe '#submit_current_period_report!' do
    let(:report) { create(:report) }
    let(:current_date) { Date.new(2025, 6, 10) }

    before do
      allow(Date).to receive(:current).and_return(current_date)
    end

    context 'with hours in current period' do
      before do
        create(:hours_log, report: report, date: current_date)
      end

      it 'returns true' do
        expect(report.submit_current_period_report!).to be true
      end

      it 'calls the callback when configured' do
        callback_called = false
        ReportableRails.configure do |config|
          config.report_submitted_callback = ->(r) { callback_called = true }
        end

        report.submit_current_period_report!
        expect(callback_called).to be true
      end
    end

    context 'without hours in current period' do
      it 'returns false' do
        expect(report.submit_current_period_report!).to be false
      end
    end
  end
end

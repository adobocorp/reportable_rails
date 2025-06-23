require 'rails_helper'

RSpec.describe HoursLog do
  let(:report) { create(:report) }
  let(:hours_log) { create(:hours_log, report: report) }

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:hours_log)).to be_valid
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:hours) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
    it { is_expected.to validate_numericality_of(:hours).is_greater_than(0).is_less_than_or_equal_to(24) }

    context 'with invalid hours' do
      it 'is invalid with hours > 24' do
        hours_log = build(:hours_log, hours: 25)
        expect(hours_log).not_to be_valid
      end

      it 'is invalid with negative hours' do
        hours_log = build(:hours_log, hours: -1)
        expect(hours_log).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
  end

  describe '#current_period?' do
    context 'when date is within current period' do
      let(:hours_log) { build(:hours_log, date: Date.current) }

      it 'returns true' do
        expect(hours_log.current_period?).to be true
      end
    end

    context 'when date is outside current period' do
      let(:hours_log) { build(:hours_log, date: 1.month.ago) }

      it 'returns false' do
        expect(hours_log.current_period?).to be false
      end
    end
  end
end

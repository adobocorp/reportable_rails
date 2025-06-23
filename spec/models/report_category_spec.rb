require 'rails_helper'

RSpec.describe ReportCategory do
  let(:category) { create(:report_category) }
  it { is_expected.to have_many(:reports) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:description).is_at_most(1000) }

  describe 'name uniqueness' do
    let!(:existing_category) { create(:report_category, name: 'Test Category') }

    it 'rejects duplicate names' do
      new_category = build(:report_category, name: 'Test Category')
      expect(new_category).not_to be_valid
      expect(new_category.errors[:name]).to include('has already been taken')
    end

    it 'rejects duplicate names with different case' do
      new_category = build(:report_category, name: 'TEST CATEGORY')
      expect(new_category).not_to be_valid
      expect(new_category.errors[:name]).to include('has already been taken')
    end

    it 'allows different names' do
      new_category = build(:report_category, name: 'Different Category')
      expect(new_category).to be_valid
    end
  end

  describe '.default_category' do
    it 'creates default category if it does not exist' do
      expect {
        described_class.default_category
      }.to change(described_class, :count).by(1)
    end

    it 'returns existing default category' do
      default = create(:report_category, name: ReportableRails.configuration.default_category_name)
      expect(described_class.default_category).to eq(default)
    end
  end

  describe '#prevent_deactivating_default_category' do
    let(:default_category) { create(:report_category, name: ReportableRails.configuration.default_category_name) }

    it 'prevents deactivating default category' do
      default_category.active = false
      expect(default_category).not_to be_valid
      expect(default_category.errors[:active]).to include("cannot deactivate the default category")
    end
  end

  describe '.deactivate' do
    it 'deactivates non-default category' do
      category = create(:report_category, name: 'Custom')
      expect(described_class.deactivate('Custom')).to be true
      expect(category.reload.active).to be false
    end

    it 'prevents deactivating default category' do
      create(:report_category, name: ReportableRails.configuration.default_category_name)
      expect(described_class.deactivate(ReportableRails.configuration.default_category_name)).to be false
    end
  end
end

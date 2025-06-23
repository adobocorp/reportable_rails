module ReportableRails
  module Models
    module ReportCategory
      extend ActiveSupport::Concern

      included do
        has_many :reports, dependent: :nullify

        validates :name, presence: true, uniqueness: { case_sensitive: false }
        validates :description, length: { maximum: 1000 }
        validates :active, inclusion: { in: [true, false] }
        validate :prevent_deactivating_default_category

        # Scopes
        scope :active, -> { where(active: true) }
        scope :ordered, -> { order(:name) }

        before_validation :set_default_active
        before_destroy :prevent_destroying_default_category

        private

        def set_default_active
          self.active = true if active.nil?
        end

        def prevent_deactivating_default_category
          if name == ReportableRails.configuration.default_category_name && !active
            errors.add(:active, "cannot deactivate the default category")
          end
        end

        def prevent_destroying_default_category
          if name == ReportableRails.configuration.default_category_name
            errors.add(:base, "cannot delete the default category")
            throw :abort
          end
        end
      end

      module ClassMethods
        # Find or create a category by name
        def find_or_create_by_name(name, description: nil)
          find_or_create_by(name: name) do |category|
            category.description = description if description.present?
          end
        end

        # Get or create the default category
        def default_category
          find_or_create_by_name(ReportableRails.configuration.default_category_name,
                                description: 'Default category for uncategorized reports')
        end

        # Deactivate a category without deleting it
        def deactivate(name)
          return false if name == ReportableRails.configuration.default_category_name
          category = find_by(name: name)
          category&.update(active: false)
        end
      end
    end
  end
end

module ReportableRails
  module Models
    module ReportCategory
      extend ActiveSupport::Concern

      included do
        has_many :reports, class_name: 'ReportableRails::Report', dependent: :nullify

        validates :name, presence: true, uniqueness: { case_sensitive: false }
        validates :description, length: { maximum: 1000 }
        validates :active, inclusion: { in: [true, false] }

        # Scopes
        scope :active, -> { where(active: true) }
        scope :ordered, -> { order(:name) }

        before_validation :set_default_active

        private

        def set_default_active
          self.active = true if active.nil?
        end
      end

      module ClassMethods
        # Find or create a category by name
        def find_or_create_by_name(name, description: nil)
          find_or_create_by(name: name) do |category|
            category.description = description if description.present?
          end
        end

        # Deactivate a category without deleting it
        def deactivate(name)
          category = find_by(name: name)
          category&.update(active: false)
        end
      end
    end
  end
end

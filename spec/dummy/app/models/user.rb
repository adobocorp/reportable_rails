class User < ApplicationRecord
  # Add any user-specific functionality needed for testing
  validates :email, presence: true
end

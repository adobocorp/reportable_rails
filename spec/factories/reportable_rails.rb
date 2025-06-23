FactoryBot.define do
  factory :report do
    association :owner, factory: :user
    association :report_category, factory: :report_category, strategy: :build
  end

  factory :report_category do
    sequence(:name) { |n| "Category #{n}" }
    description { "A test category" }
    active { true }
  end

  factory :hours_log do
    association :report
    hours { rand(1..8) }
    date { Date.current }
    description { "Test work entry" }
  end

  # This is a placeholder factory - implement according to your User class
  factory :user do
    email {
      'user' + rand(1000).to_s + '@example.com'
    }
    # Add user attributes as needed
  end
end

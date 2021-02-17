# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:id) { |n| n }

    name   { 'My Automated Product' }
    anchor { false }

    trait :as_anchor do
      anchor { true }
    end
  end

  initialize_with { new(**attributes) }
end

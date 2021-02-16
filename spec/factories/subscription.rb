# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    sequence(:id) { |n| n }

    starts_at { Time.now }
    ends_at   { starts_at + 24 * 30 * 86_400 }

    initialize_with { new(**attributes) }
  end
end

# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    sequence(:id) { |n| n }

    name             { 'Fabulous Customer' }
    subscription_ids { build_list(:subscription, 3).map(&:id) }

    initialize_with { new(**attributes) }
  end
end

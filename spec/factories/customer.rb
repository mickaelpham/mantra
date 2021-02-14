# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name          { 'Fabulous Customer' }
    subscriptions { build_list(:subscription, 3) }

    initialize_with { new(**attributes) }
  end
end

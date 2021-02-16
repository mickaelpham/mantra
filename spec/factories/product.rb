# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:id) { |n| n }

    name { 'My Automated Product' }
  end

  initialize_with { new(**attributes) }
end

# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :rule do
    sequence(:id) { |n| n }

    configured_product_id { build(:product, name: 'Configured Product').id }
    optional_product_id   { build(:product, name: 'Optional Product').id }

    trait :wall_to_wall do
      quantity_constraint { QuantityConstraint::WallToWall }
    end

    trait :less_than_or_equal do
      quantity_constraint { QuantityConstraint::LessThanOrEqual }
    end

    initialize_with { new(**attributes) }
  end
end

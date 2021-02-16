# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :rule do
    configured { build(:product, name: 'Configured Product') }
    optional   { build(:product, name: 'Optional Product') }

    trait :wall_to_wall do
      quantity_constraint { QuantityConstraint::WallToWall }
    end

    trait :less_than_or_equal do
      quantity_constraint { QuantityConstraint::LessThanOrEqual }
    end

    initialize_with { new(**attributes) }
  end
end

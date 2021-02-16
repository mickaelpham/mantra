# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :sku, class: 'SKU' do
    sequence(:id) { |n| n }

    product_id      { build(:product).id }
    subscription_id { build(:subscription).id }
    quantity        { 1 }

    initialize_with { new(**attributes) }
  end
end

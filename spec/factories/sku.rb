# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :sku, class: 'SKU' do
    product  { build(:product) }
    quantity { 1 }

    initialize_with { new(**attributes) }
  end
end

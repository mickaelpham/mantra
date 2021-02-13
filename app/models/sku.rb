# typed: strict
# frozen_string_literal: true

class SKU < T::Struct
  const :product, Product
  prop :quantity, Integer, default: 1
end

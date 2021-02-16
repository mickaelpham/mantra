# typed: strict
# frozen_string_literal: true

class SKU < T::Struct
  const :id,              T.nilable(Integer)
  const :product_id,      Integer
  const :subscription_id, Integer
  prop  :quantity,        Integer, default: 1
end

# typed: strict
# frozen_string_literal: true

class Rule < T::Struct
  const :configured, Product
  const :optional,   Product
  const :quantity,   QuantityConstraint
end

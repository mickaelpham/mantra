# typed: strict
# frozen_string_literal: true

class QuantityConstraint < T::Enum
  enums do
    WallToWall      = new
    LessThanOrEqual = new
  end
end

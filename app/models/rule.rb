# typed: strict
# frozen_string_literal: true

class Rule < T::Struct
  extend T::Sig

  const :configured,          Product
  const :optional,            Product
  const :quantity_constraint, T.nilable(QuantityConstraint)

  sig { params(skus: T::Array[SKU]).returns(T::Boolean) }
  def valid_given?(skus)
    # Map the product to the SKU for ease of access. Note that this method
    # assumes no duplicate products are passed. Validation should happen at
    # the subscription level, not here.
    products = skus.each_with_object({}) { |sku, hsh| hsh[sku.product] = sku }
    return true unless products.key?(configured) && products.key?(optional)

    configured_qty = products[configured].quantity
    optional_qty   = products[optional].quantity

    case quantity_constraint
    when QuantityConstraint::WallToWall      then optional_qty == configured_qty
    when QuantityConstraint::LessThanOrEqual then optional_qty <= configured_qty
    else true # no specific constraint configured
    end
  end
end

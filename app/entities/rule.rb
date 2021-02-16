# typed: strict
# frozen_string_literal: true

class Rule < T::Struct
  extend T::Sig

  const :id,                    T.nilable(Integer)
  const :configured_product_id, Integer
  const :optional_product_id,   Integer
  const :quantity_constraint,   T.nilable(QuantityConstraint)

  sig { params(skus: T::Array[SKU]).returns(T::Boolean) }
  def valid_given?(skus)
    # Map the product_id to the SKU for ease of access. Note that this method
    # assumes no duplicate products are passed. Validation should happen at the
    # subscription level, not here.
    skus_by_product_id = skus.each_with_object({}) { |sku, hsh| hsh[sku.product_id] = sku }
    return true unless skus_by_product_id.key?(configured_product_id) && skus_by_product_id.key?(optional_product_id)

    configured_qty = skus_by_product_id[configured_product_id].quantity
    optional_qty   = skus_by_product_id[optional_product_id].quantity

    case quantity_constraint
    when QuantityConstraint::WallToWall      then optional_qty == configured_qty
    when QuantityConstraint::LessThanOrEqual then optional_qty <= configured_qty
    else true # no specific constraint configured
    end
  end
end

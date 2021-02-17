# typed: true
# frozen_string_literal: true

# frozen_literal_string: true

class ProductDependencyMediator
  extend T::Sig

  sig { params(rules: T::Array[Rule], skus: T::Array[SKU]).void }
  def initialize(rules, skus)
    @rules = rules
    @skus = skus
  end

  sig { returns(T::Boolean) }
  def valid?
    sku_product_ids.all? do |sku_product_id|
      rules = rules_by_optional_product_id.fetch(sku_product_id, [])

      if rules.empty?
        # when there are no rule, the product MUST be an anchor product
        T.must(product_repository.find(sku_product_id)).anchor?
      else
        # when there is at least one rule, there MUST be a corresponding product in the SKUs
        !rules.map(&:configured_product_id).to_set.intersection(sku_product_ids).empty?
      end
    end
  end

  private

  attr_reader :rules, :skus

  sig { returns(T::Hash[Integer, T::Array[Rule]]) }
  def rules_by_optional_product_id
    @rules_by_optional_product_id ||= rules.each_with_object(Hash.new { |hsh, key| hsh[key] = [] }) do |rule, hsh|
      hsh[rule.optional_product_id] << rule
    end
  end

  sig { returns(T::Set[Integer]) }
  def sku_product_ids
    @sku_product_ids ||= skus.map(&:product_id).to_set
  end

  sig { returns(ProductRepository) }
  def product_repository
    @product_repository ||= ProductRepository.new
  end
end
